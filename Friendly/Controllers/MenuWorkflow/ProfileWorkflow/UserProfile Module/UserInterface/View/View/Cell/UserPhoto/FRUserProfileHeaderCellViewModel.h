//
//  FRUserProfileHeaderCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 30.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
#import "FRUserProfileFriendActionView.h"

@class FRUserModel;

@protocol FRUserProfileHeaderCellViewModelDelegate <NSObject>

- (void)saveSelected;
- (void)settingSelected:(NSString*)userId;
- (void)backSelected;

- (void)pendingSelected:(NSString*)userId;
- (void)addFriendSelected:(NSString*)userId;
- (void)inviteToEventSelected:(NSString*)userId;
- (void)friendsSelected:(NSString*)userId;

@end

@interface FRUserProfileHeaderCellViewModel : NSObject

@property (nonatomic, weak) id<FRUserProfileHeaderCellViewModelDelegate> delegate;

+ (instancetype)initWithModel:(UserEntity*)model;
- (void)updateWithModel:(UserEntity*)model;

@property (nonatomic, strong) NSString* profession;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSString* away;
@property (nonatomic, assign) FRFriendActionMode friendMode;
@property (nonatomic, assign) BOOL isPrivateAccount;

- (void)updateWallImage:(UIImageView*)wallImage;
- (void)updateUserPhoto:(UIImageView*)userPhoto;

- (void)setUserModel:(UserEntity*)model;

- (UserEntity*)domainModel;

- (void)saveSelected;
- (void)settingSelected;
- (void)backSelected;


- (void)pendingSelected;
- (void)addFriendSelected;
- (void)inviteToEventSelected;
- (void)friendsSelected;

@end
