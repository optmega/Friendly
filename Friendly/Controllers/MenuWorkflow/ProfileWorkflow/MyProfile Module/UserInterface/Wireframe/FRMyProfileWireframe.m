//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileWireframe.h"
#import "FRMyProfileInteractor.h"
#import "FRMyProfileVC.h"
#import "FRMyProfilePresenter.h"
#import "FRUserModel.h"
#import "FREditProfileWireframe.h"
#import "FRSettingWireframe.h"
#import "FRMyProfileStatusInput.h"
#import "FRFriendRequestsWireframe.h"
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramLoginResponse.h"
#import "FRUserManager.h"
#import "FRSocialTransport.h"
#import "FRInstagramPhotoPreviewController.h"
#import "FRUserProfileWireframe.h"
#import "FRSettingsTransport.h"
#import "FRMyEventsGuestViewController.h"
#import "FRTransitionAnimator.h"
#import "FREventPreviewController.h"
#import "FRMyProfileAddMobileViewController.h"
#import "SimpleAuth.h"
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>
#import "BSHudHelper.h"

@interface FRMyProfileWireframe () <FBSDKAppInviteDialogDelegate>

@property (nonatomic, weak) FRMyProfilePresenter* presenter;
@property (nonatomic, weak) UINavigationController* presentedController;

@property (nonatomic, assign) BOOL isNavBarHide;

@property (nonatomic, strong) UIViewController* fromViewController;

@end

@implementation FRMyProfileWireframe


- (void)presentMyProfileWithAnimationFrom:(UIViewController*)viewController {
    
    self.isNavBarHide = true;
    
    FRMyProfileVC* myProfileController = [FRMyProfileVC new];
    myProfileController.backButton.hidden = false;
    FRMyProfileInteractor* interactor = [FRMyProfileInteractor new];
    FRMyProfilePresenter* presenter = [FRMyProfilePresenter new];
    
    interactor.output = presenter;
    
    myProfileController.eventHandler = presenter;
    self.presenter = presenter;
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:myProfileController];
    
    self.fromViewController = viewController;
     self.myProfileController = myProfileController;
    
    UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:myProfileController];
    
    self.presentedController = nv;
    BSDispatchBlockToMainQueue(^{
        
        [[FRTransitionAnimator new] presentViewController:nv from:viewController];
    });
}


- (void)presentMyProfileControllerFromNavigationController:(UINavigationController*)nc withBackButton:(BOOL)isBackButtonPresenting
{
    self.isNavBarHide = nc.navigationBarHidden;
    FRMyProfileVC* myProfileController = [FRMyProfileVC new];
    myProfileController.backButton.hidden = !isBackButtonPresenting;
    FRMyProfileInteractor* interactor = [FRMyProfileInteractor new];
    FRMyProfilePresenter* presenter = [FRMyProfilePresenter new];
    
    interactor.output = presenter;
    
    myProfileController.eventHandler = presenter;
    self.presenter = presenter;
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:myProfileController];
    
    self.myProfileController = myProfileController;
    self.presentedController = nc;

    
    BSDispatchBlockToMainQueue(^{
       
        [nc pushViewController:myProfileController animated:true];
//        [nc presentViewController:myProfileController animated:true completion:nil];
//        [nc setViewControllers:@[myProfileController]];
    });
    
    
}

- (void)dismissMyProfileController
{
    if (self.fromViewController) {
        [[FRTransitionAnimator new] dismissViewController:self.fromViewController from:self.myProfileController];
    } else {
        [self.fromViewController.navigationController popViewControllerAnimated:true];
        [self.presentedController popViewControllerAnimated:true];
    }
}

- (void)presentSettingController
{
    [[FRSettingWireframe new] presentSettingControllerFromController:self.presentedController];
}

- (void)presentEditProfile:(UserEntity*)profile
{
    [[FREditProfileWireframe new] presentEditProfileControllerFromNavigationController:self.presentedController userModel:profile];
}

- (void)presentStatusInputController
{
    FRMyProfileStatusInput* inputVC = [FRMyProfileStatusInput new];
    inputVC.delegate = (id<FRMyProfileStatusInputDelegate>)self.presenter;
    [self.myProfileController presentViewController:inputVC animated:YES completion:nil];
}

- (void)presentInstagramAuthController
{
    
    //        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    //        [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
    //            [storage deleteCookie:cookie];
    //        }];
    
    
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
                    [self.presenter reloadInstagram];
                } failure:^(NSError *error) {
                                                                                                                                           //
                                                                                                                                       }];

                
            }
        }
        
    }];

    
//
//            InstagramSimpleOAuthViewController *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:kClientID                                                                                clientSecret:@"dab460cb3f574da38507676960ad7ac2"
//                                                                                                                  callbackURL:[NSURL URLWithString:@"http://google.com/"]
//                                                                                                                   completion:^(InstagramLoginResponse *response, NSError *error) {
//                                                                                                                       NSLog(@"My Access Token is:  %@", response.accessToken);
//                                                                                                                       [FRUserManager sharedInstance].instaToken = response.accessToken;
//                                                                                                                       [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"instaToken"];
//                                                                                                                       [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
//                                                                                                                           //
//                                                                                                                       } failure:^(NSError *error) {
//                                                                                                                           //
//                                                                                                                       }];
//                                                                                                                   }];
//            [self.presentedController setNavigationBarHidden:NO animated:YES];
//            
//            [self.presentedController pushViewController:viewController
//                                                animated:YES];

    
       }

-(void)presentPreviewControllerWithImage:(UIImage*)image
{
    FRInstagramPhotoPreviewController* vc = [FRInstagramPhotoPreviewController new];
    [vc updateWithPhoto:image];
    [self.myProfileController presentViewController:vc animated:YES completion:nil];
}

- (void)showUserProfile:(NSString*)userId
{
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
    } failure:^(NSError *error) {
        //
    }];
    FRUserProfileWireframe* uWF = [FRUserProfileWireframe new];
//    [uWF presentUserProfileControllerFromNavigationController:self.presentedController user:user withAnimation:YES];

    [uWF presentUserProfileFromViewController:self.myProfileController user:user fromLoginFlow:NO];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    self.myProfileController.canUpdate = false;
    FRUserProfileWireframe* uWF = [FRUserProfileWireframe new];
//    [uWF presentUserProfileControllerFromNavigationController:self.presentedController user:user withAnimation:YES];
    [uWF presentUserProfileFromViewController:self.myProfileController user:user fromLoginFlow:NO];
}

- (void)presentAddMobileController
{
    FRMyProfileAddMobileViewController* addMobileVC = [FRMyProfileAddMobileViewController new];
    [self.myProfileController presentViewController:addMobileVC animated:YES completion:nil];
}

- (void)presentInviteFriendsController
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self.myProfileController title:nil message:nil];
    [FRSettingsTransport getInviteUrl:^(NSString *url) {
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self.myProfileController title:nil message:nil];
        FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
        content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:url]];
        [FBSDKAppInviteDialog showFromViewController:self.myProfileController
                                         withContent:content
                                            delegate:self];
        
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}



@end
