//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileWireframe.h"
#import "FRUserProfileInteractor.h"
#import "FRUserProfileVC.h"
#import "FRUserProfilePresenter.h"
#import "FRUserProfileStatusInput.h"
#import "FRTransitionAnimator.h"
#import "FREventsVC.h"
#import "FREventPreviewController.h"
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramLoginResponse.h"
#import "FRUserManager.h"
#import "FRPrivateChatVC.h"
#import "FRSocialTransport.h"
#import "FRInstagramPhotoPreviewController.h"
#import "FRInviteToEventViewController.h"
#import "FRPrivateChatWireframe.h"
#import "FRSettingsTransport.h"
#import "FRMyEventsGuestViewController.h"
#import "FRFriendRequestsVC.h"
#import "FRFriendsEventsVC.h"
#import "FRMyProfileVC.h"
#import "FRMyProfileInteractor.h"
#import "FRMyProfilePresenter.h"
#import "FRHomeVC.h"
#import "FRPrivateRoomChatWireframe.h"
#import "SimpleAuth.h"

@interface FRUserProfileWireframe ()

@property (nonatomic, weak) FRUserProfilePresenter* presenter;
@property (nonatomic, weak) FRUserProfileVC* userProfileController;
@property (nonatomic, weak) UINavigationController* presentedController;
@property (nonatomic, assign) BOOL isFromLoginFlow;

@property (nonatomic, strong) UIViewController* fromViewController;

@end

@implementation FRUserProfileWireframe

- (void)presentUserProfileFromViewController:(UIViewController*)vc user:(UserEntity*)user fromLoginFlow:(BOOL)isFromLoginFlow{
    
    if (!([FRConnetctionManager isConnected]) || user.objectID == nil) {
        return;
    }
    
    self.isFromLoginFlow = isFromLoginFlow;
    
    FRUserProfileVC* userProfileController = [FRUserProfileVC new];
    userProfileController.user = user;
    FRUserProfileInteractor* interactor = [FRUserProfileInteractor new];
    FRUserProfilePresenter* presenter = [FRUserProfilePresenter new];
    
    interactor.output = presenter;
    
    userProfileController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    
    [presenter configurePresenterWithUserInterface:userProfileController user:user];
    
    self.fromViewController = vc;
    self.userProfileController = userProfileController;
    self.presenter = presenter;
    
    BSDispatchBlockToMainQueue(^{
        if (self.isFromLoginFlow)
        {
            [vc presentViewController:userProfileController animated:YES completion:nil];
        }
        else
        {
        
        [[FRTransitionAnimator alloc] presentViewController:userProfileController from:vc];

        }
    });

}

- (void)dismissUserProfileController
{
    
    if (self.complite) {
        self.complite();
    }
    
    if (self.isFromLoginFlow)
    {
        [self.userProfileController dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
    [[FRTransitionAnimator alloc] dismissViewController:self.fromViewController from:self.userProfileController];
    }
    
    return;
}

- (void)presentInputControllerWithUserId:(NSString*)userId
{
    FRUserProfileStatusInput* inputVC = [FRUserProfileStatusInput new];
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity* userProfile, NSArray *mutualFriends) {
        UserEntity* e = [FRSettingsTransport getUserWithId:userId success:nil failure:nil];
        if ([e.isFriend isEqual:@2])
        {
            inputVC.heightFooter = 233;
        }
        else
        {
            inputVC.heightFooter = 185;
        }
        inputVC.userId = userId;
        inputVC.delegate = (id<FRUserProfileStatusInputDelegate>)self.presenter;
        [self.userProfileController presentViewController:inputVC animated:true completion:nil];
    
    } failure:^(NSError *error) {
        //
    }];
    if (user)
    {
        NSLog([NSString stringWithFormat:@"%@", user.isFriend]);
        if ([user.isFriend isEqual:@2])
        {
            inputVC.heightFooter = 233;
        }
        else
        {
            inputVC.heightFooter = 185;
        }
        inputVC.userId = userId;
        inputVC.delegate = (id<FRUserProfileStatusInputDelegate>)self.presenter;
        [self.userProfileController presentViewController:inputVC animated:true completion:nil];
    }
}

- (void)presentAlertController:(UIAlertController*)alert
{
    [self.userProfileController presentViewController:alert animated:YES completion:nil];
}

- (void)presentInviteToEventController:(NSString*)userId
{
    FRInviteToEventViewController* inviteToEventVC = [FRInviteToEventViewController new];
    inviteToEventVC.userId = userId;
    [self.userProfileController presentViewController:inviteToEventVC animated:YES completion:nil];
}

- (void)presentInstagramAuthController
{
    
    if (!([FRConnetctionManager isConnected])) {
        return;
    }
    
//            NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//            [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
//                [storage deleteCookie:cookie];
//            }];
    
    
    NSString *provider = @"instagram";
    SimpleAuth.configuration[@"instagram"] = @{
                                               @"client_id" : kClientID,
                                               SimpleAuthRedirectURIKey : @"http://google.com/"
                                               };
    //    if ([configuration count] == 0) {
    //        NSLog(@"It looks like you haven't configured the \"%@\" provider.\n"
    //              "Consider calling +[SimpleAuth configuration] in `application:willFinishLaunchingWithOptions: "
    //              "and providing all relevant options for the given provider.",
    //              provider);
    //        return;
    //    }
    __block NSString* token = @"";
    [SimpleAuth authorize:provider completion:^(id responseObject, NSError *error) {
        NSLog(@"\nResponse: %@\nError:%@", responseObject, error);
        NSDictionary* response = (NSDictionary*)responseObject;
        if (response)
        {
            NSDictionary* cred = [response objectForKey:@"credentials"];
            if (cred)
            {
                token = (NSString*)[cred objectForKey:@"token"];
                [FRUserManager sharedInstance].instaToken = token;
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"instaToken"];
                [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
                    //
                } failure:^(NSError *error) {
                    //
                }];
                
                
            }
        }
        
    }];

    
//    InstagramSimpleOAuthViewController *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:kClientID                                                                                clientSecret:@"dab460cb3f574da38507676960ad7ac2"
//                                                                                                          callbackURL:[NSURL URLWithString:@"http://google.com"]
//                                                                                                           completion:^(InstagramLoginResponse *response, NSError *error) {
//                                                                                                               NSLog(@"My Access Token is:  %@", response.accessToken);
//                                                                                                               [FRUserManager sharedInstance].instaToken = response.accessToken;
//                                                                                                               [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"instaToken"];
//                                                                                                               [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
//                                                                                                                   //
//                                                                                                               } failure:^(NSError *error) {
//                                                                                                                   //
//                                                                                                               }];                            }];
//    
//    [self.userProfileController presentViewController:viewController animated:YES completion:nil];
}

-(void)presentPreviewControllerWithImage:(UIImage*)image
{
    FRInstagramPhotoPreviewController* vc = [FRInstagramPhotoPreviewController new];
    [vc updateWithPhoto:image];
    [self.userProfileController presentViewController:vc animated:YES completion:nil];
}

- (void)presentChatWithUser:(UserEntity *)user
{
    
    [[FRPrivateRoomChatWireframe new] presentPrivateRoomChatControllerFromNavigationController:self.userProfileController userEntity:user];
//    [[FRPrivateChatWireframe new] presentPrivateChatControllerFromNavigationController:self.userProfileController forUser:user];
}

-(void)presentUserProfileControllerWithUserId:(NSString *)userId
{
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
    } failure:^(NSError *error) {
        //
    }];
    
    FRUserProfileWireframe* uWF = [FRUserProfileWireframe new];
    [uWF presentUserProfileFromViewController:self.userProfileController user:user fromLoginFlow:NO];
//    [uWF presentUserProfileControllerFromNavigationController:self.presentedController user:user withAnimation:YES];

    //    [self presentUserProfileControllerFromNavigationController:self.userProfileController userId:userId];
}


@end
