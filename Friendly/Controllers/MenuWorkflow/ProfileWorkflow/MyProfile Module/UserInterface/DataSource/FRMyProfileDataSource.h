//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRUserModel;


@protocol FRMyProfileDataSourceDelegate <NSObject>

- (void)saveEditSelected;
- (void)settingSelected;
- (void)statusSelected;
- (void)connectInstagramSelected;
- (void)updateWallImage:(NSString*)imageUrl;
- (void)showPreviewWithImage:(UIImage*)image;
- (void)showUserProfile:(NSString*)userId;
- (void)showUserProfileWithEntity:(UserEntity*)user;
- (void)changeStatus:(NSInteger)status;
- (void)presentAddMobileController;
- (void)presentInviteFriendsController;

@end

@interface FRMyProfileDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRMyProfileDataSourceDelegate> delegate;

- (void)setupStorage;
- (void)updateStorage:(CurrentUser*)model andUsers:(NSArray*)users;
- (void)updateUserStatusStatus:(NSString*)status;

@end
