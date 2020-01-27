//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRUserModel, FRProfileDomainModel;


@protocol FREditProfileDataSourceDelegate <NSObject>

- (void)emptyEventField:(NSString*)message;
- (void)changeUserPhoto;
- (void)changeWallPhoto;
- (void)saveSelected;
- (void)settingSelected;
- (void)updateWallImage:(UIImage*)image;
- (void)updateWallImageUrl:(NSString*)imageUrl;

@end

@interface FREditProfileDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FREditProfileDataSourceDelegate> delegate;

- (void)setupStorageWithUserModel:(UserEntity*)userModel;
- (FRProfileDomainModel*)profile;
- (void)updateUserPhoto:(UIImage*)photo;
- (void)updateWallPhoto:(UIImage*)wallPhoto;

@end
