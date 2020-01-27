//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRUserModel;


@protocol FRUserProfileDataSourceDelegate <NSObject>

- (void)saveSelected;
- (void)settingSelected:(NSString*)userId;
- (void)backSelected;
- (void)connectInstagram;
- (void)updateWallImage:(NSString*)imageUrl;
- (void)addFriendSelected:(NSString*)userId;
- (void)showPreviewWithImage:(UIImage*)image;
- (void)inviteToEventSelected:(NSString*)userId;
- (void)showUserProfile:(NSString*)userId;

@end

@interface FRUserProfileDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRUserProfileDataSourceDelegate> delegate;


- (void)setupStorage;
- (void)updateStorageWithUserModel:(UserEntity*)user withMutual:(NSArray*)mutual isPrivateAccount:(BOOL)isPrivateAccount;
@end
