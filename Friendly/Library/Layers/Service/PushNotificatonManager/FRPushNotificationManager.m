//
//  FRPushNotificationManager.m
//  Friendly
//
//  Created by Sergey Borichev on 12.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPushNotificationManager.h"
#import "FRUserProfileWireframe.h"
#import "FRHomeScreenWireframe.h"
#import "FRHomeScreenVC.h"
#import "FRSettingsTransport.h"
#import "FREventPreviewController.h"
#import "CWStatusBarNotification.h"
#import "FRPushHeaderView.h"
#import "FRPushNotificationConstants.h"

#import "FRPrivateChatWireframe.h"
#import "FRSettingsTransport.h"

#import "FRFriendRequestsWireframe.h"
#import "FREventRequestsViewController.h"
#import "FRPrivateRoomChatWireframe.h"
#import "FRPushModel.h"
#import "FREventTransport.h"
#import "MBProgressHUD.h"

@interface FRPushNotificationManager ()

@property (nonatomic, strong) CWStatusBarNotification* notificationBar;

@end

@implementation FRPushNotificationManager

+ (instancetype)sharedInstance
{
    static FRPushNotificationManager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FRPushNotificationManager alloc] init];
    });
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        self.notificationBar = [CWStatusBarNotification new];
        self.notificationBar.notificationAnimationInStyle = CWNotificationAnimationStyleTop;
        self.notificationBar.notificationAnimationOutStyle = CWNotificationAnimationStyleTop;
        self.notificationBar.notificationStyle = CWNotificationStyleNavigationBarNotification;
        self.notificationBar.notificationLabelBackgroundColor = [UIColor blueColor];
        self.notificationBar.notificationAnimationType = CWNotificationAnimationTypeOverlay;

    }
    
    return self;
}

//OpenURL

- (void)handleOpenUrl:(NSURL *)url {
    
    NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:url
                                                resolvingAgainstBaseURL:NO];
    
    if ([[urlComponents host].uppercaseString isEqualToString:@"EVENT"]) {
        
        NSArray* paths = [[urlComponents path] componentsSeparatedByString:@"/"];
        NSLog(@"%@", paths);
        
        FRPushModel* model = [FRPushModel new];
        model.event_id = paths.lastObject;
        model.notification_type = [NSString stringWithFormat:@"%ld", (long)FRPushNotificationTypeSomeoneInvitesYouToAnEvent];
        
        [self _routerWithNotification:model];
    
    }
    
}


- (void)handleNotificationActiveState:(NSDictionary *)userInfo
{
//    BSDispatchBlockToBackgroundQueue(^{
    
        NSError* error;
        FRPushModel* pushModel = [[FRPushModel alloc] initWithDictionary:userInfo error:&error];
        
        if (error) {
            
            return ;
        }
        
        if (pushModel.room_id && [FRUserManager sharedInstance].openRoomId.integerValue == pushModel.room_id.integerValue)
        {
            return;
        }
       
        if (pushModel.event_id && [FRUserManager sharedInstance].currentChatGroupId.integerValue == pushModel.event_id.integerValue)
        {
            return;
        }
        
        FRPushHeaderView* view = [FRPushHeaderView new];
        view.backgroundColor = [UIColor bs_colorWithHexString:kAlertsColor];
        
        FRPushHeaderViewModel* model = [FRPushHeaderViewModel initWithPushData:pushModel];
        [view updateViewModel:model];
        
        if (model.canShowAlert) {
            
            BSDispatchBlockToMainQueue(^{
                
                [self.notificationBar displayNotificationWithView:view forDuration:3 withTappedBlock:^{
                    [self _routerWithNotification:pushModel];
                }];
            });
        }
//    });

}

- (void)_routerWithNotification:(FRPushModel*)userInfo
{
    
    FRPushNotificationType type = userInfo.notification_type.integerValue;
    
    UIViewController* rootController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    [MBProgressHUD showHUDAddedTo:rootController.view animated:true];
    
    [rootController dismissViewControllerAnimated:NO completion:nil];
    switch (type) {
            
        case FRPushNotificationTypeSomeoneAddsYou:
        {
            [MBProgressHUD hideHUDForView:rootController.view animated:YES];
            [[FRFriendRequestsWireframe new] presentFriendRequestsControllerFromNavigationController:(UINavigationController*)rootController];
            
        }break;
            
        case FRPushNotificationTypeSomeoneAsksToJoinYourEvent:
        {
            [MBProgressHUD hideHUDForView:rootController.view animated:YES];
            FREventRequestsViewController* vc = [FREventRequestsViewController new];
            [rootController presentViewController:vc animated:YES completion:nil];
        }break;
            
        case FRPushNotificationTypeSomeoneInvitesYouToAnEvent:
        {
            [FREventTransport getEventInfoWithId:userInfo.event_id success:^(FREvent *event) {
                
                FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:CGRectZero];
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [rootController presentViewController:vc animated:YES completion:nil];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [self showAlertWithError:error fromViewController:rootController];
            
            }];

        }break;
            
        case FRPushNotificationTypeNewMessage:
        {
            
            if ([userInfo.user_id isEqualToString:WELCOME_TEMP_USER] || userInfo.user_id == nil || userInfo.user_id.length == 0 || [userInfo.user_id isEqualToString:[FRUserManager sharedInstance].userId]) {
                
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];

                UserEntity* userProfile = [UserEntity MR_createEntity];
                userProfile.user_id = WELCOME_TEMP_USER;
                userProfile.firstName = @"Welcome aboard";
                userProfile.userPhoto = @"https://s3-us-west-2.amazonaws.com/friendlyapp-user-avatars/Intro-message-min-2016-11-17.png";
                
                [userProfile.managedObjectContext save:nil];
                
                [[FRPrivateRoomChatWireframe new] presentPrivateRoomChatControllerFromNavigationController:(UINavigationController*)rootController userEntity:userProfile];
                
                return;
            }
            
            UserEntity* user = [FRSettingsTransport getUserWithId:userInfo.user_id success:^(UserEntity *userProfile, NSArray *mutualFriends) {
    
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                
                if ([userProfile.user_id isEqualToString:[FRUserManager sharedInstance].userId]) {
                    return ;
                }
                
                [[FRPrivateRoomChatWireframe new] presentPrivateRoomChatControllerFromNavigationController:(UINavigationController*)rootController userEntity:userProfile];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [self showAlertWithError:error fromViewController:rootController];
            }];
            
            if (user) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [[FRPrivateRoomChatWireframe new] presentPrivateRoomChatControllerFromNavigationController:(UINavigationController*)rootController userEntity:user];
            }

        } break;
        case FRPushNotificationTypeEventReminder:
        {
            
            FREvent* event = [FREventTransport getEventForId:userInfo.event_id success:^(FREvent *event) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:CGRectZero];
                [rootController presentViewController:vc animated:YES completion:nil];
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [self showAlertWithError:error fromViewController:rootController];
            }];
            
            if (event) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:CGRectZero];
                [rootController presentViewController:vc animated:YES completion:nil];
            }
            
        }break;
            
        case FRPushNotificationTypeNewUser: {
            
            UserEntity* user = [FRSettingsTransport getUserWithId:userInfo.user_id success:^(UserEntity *userProfile, NSArray *mutualFriends) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                UserEntity * user = [FRSettingsTransport getUserWithId:userInfo.user_id success:nil failure:nil];
                
                [[FRUserProfileWireframe new] presentUserProfileFromViewController:rootController user:user fromLoginFlow:true];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [self showAlertWithError:error fromViewController:rootController];
            }];
            
            if (user) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [[FRUserProfileWireframe new] presentUserProfileFromViewController:rootController user:user fromLoginFlow:true];

            }

            
        } break;
            
        case FRPushNotificationTypeSomeoneInvitesYouToAnEventAsCohost: {
            
            [MBProgressHUD hideHUDForView:rootController.view animated:YES];
            FREventRequestsViewController* vc = [FREventRequestsViewController new];
            
            
            [rootController presentViewController:vc animated:true completion:nil];

        } break;
            
        case FacebookFriendInvitedByYouJoined: {
            
            UserEntity* user = [FRSettingsTransport getUserWithId:userInfo.user_id success:^(UserEntity *userProfile, NSArray *mutualFriends) {
                
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                
                [[FRUserProfileWireframe new] presentUserProfileFromViewController:rootController user:userProfile fromLoginFlow:false];
                
            } failure:^(NSError *error) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [self showAlertWithError:error fromViewController:rootController];
            }];
            
            if (user) {
                [MBProgressHUD hideHUDForView:rootController.view animated:YES];
                [[FRUserProfileWireframe new] presentUserProfileFromViewController:rootController user:user fromLoginFlow:false];
            }

        } break;
            
            default:
        {
            [MBProgressHUD hideHUDForView:rootController.view animated:YES];
        }
    }
  

}

- (void)showAlertWithError:(NSError*)error fromViewController:(UIViewController*)vc {
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:cancel];
    
    [vc presentViewController:alert animated:true completion:nil];
}

- (void)handleNotification:(NSDictionary *)userInfo
{
    
    NSError* error;
    FRPushModel* pushModel = [[FRPushModel alloc] initWithDictionary:userInfo error:&error];
    
    BSDispatchBlockAfter(1, ^{
        
        if([[FRUserManager sharedInstance] currentUser]) {
            
            [self _routerWithNotification:pushModel];
        }
    
    });
    
//    [FRSettingsTransport profileWithSuccess:^(UserEntity *userProfile, NSArray* mutualFriends) {
//        
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

@end
