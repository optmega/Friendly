//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserModel;
#import "FRMyProfileVC.h"

@interface FRMyProfileWireframe : NSObject

@property (nonatomic, weak) FRMyProfileVC* myProfileController;

- (void)presentMyProfileWithAnimationFrom:(UIViewController*)viewController;

- (void)presentMyProfileControllerFromNavigationController:(UINavigationController*)nc withBackButton:(BOOL)isBackButtonPresenting;
- (void)dismissMyProfileController;

- (void)presentSettingController;
- (void)presentEditProfile:(UserEntity*)profile;
- (void)presentStatusInputController;
- (void)presentInstagramAuthController;
- (void)presentPreviewControllerWithImage:(UIImage*)image;
- (void)showUserProfile:(NSString*)userId;
- (void)showUserProfileWithEntity:(UserEntity*)user;
- (void)presentAddMobileController;
- (void)presentInviteFriendsController;

@end
