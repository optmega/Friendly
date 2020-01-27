//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserModel;

@interface FRUserProfileWireframe : NSObject

@property (nonatomic, copy) BSCodeBlock complite;

- (void)presentUserProfileFromViewController:(UIViewController*)vc user:(UserEntity*)user fromLoginFlow:(BOOL)isFromLoginFlow;
- (void)ppresentUserProfileControllerFromNavigationController:(UINavigationController*)nc user:(UserEntity*)user withAnimation:(BOOL)isAnimation;
- (void)dismissUserProfileController;
- (void)presentInputControllerWithUserId:(NSString*)userId;
- (void)presentAlertController:(UIAlertController*)alert;
- (void)presentInstagramAuthController;
- (void)presentPreviewControllerWithImage:(UIImage*)image;
- (void)presentInviteToEventController:(NSString*)userId;
- (void)presentChatWithUser:(UserEntity*)user;
- (void)presentUserProfileControllerWithUserId:(NSString*)userId;

@end
