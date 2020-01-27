//
//  FRMyProfileUserPhotoCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRUserModel;


@protocol FRMyProfileUserPhotoCellViewModelDelegate <NSObject>

- (void)saveSelected;
- (void)settingSelected;
- (void)statusSelected;

@end

@interface FRMyProfileUserPhotoCellViewModel : NSObject

@property (nonatomic, weak) id<FRMyProfileUserPhotoCellViewModelDelegate> delegate;

+ (instancetype)initWithModel:(UserEntity*)model;
- (void)updateWithModel:(UserEntity*)model;

@property (nonatomic, strong) NSString* profession;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString* statusString;

@property (nonatomic, strong) UIImage* userPhotoImage;
@property (nonatomic, strong) UIImage* wallImage;


- (void)updateWallImage:(UIImageView*)wallImage;
- (void)updateUserPhoto:(UIImageView*)userPhoto;

- (void)setUserModel:(UserEntity*)model;

- (UserEntity*)domainModel;

- (void)saveSelected;
- (void)settingSelected;
- (void)statusSelected;

@end
