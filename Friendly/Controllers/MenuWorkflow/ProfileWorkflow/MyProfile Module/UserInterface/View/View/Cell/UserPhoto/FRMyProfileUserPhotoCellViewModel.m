//
//  FRMyProfileUserPhotoCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileUserPhotoCellViewModel.h"
#import "FRUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"
#import "FRStyleKit.h"

@interface FRMyProfileUserPhotoCellViewModel()

@property (nonatomic, strong) UserEntity* model;

@end

@implementation FRMyProfileUserPhotoCellViewModel


+ (instancetype)initWithModel:(UserEntity*)model
{
    FRMyProfileUserPhotoCellViewModel* viewModel = [FRMyProfileUserPhotoCellViewModel new];
//    viewModel.wallImage = model.cover_image;
    viewModel.model = model;
    
    return viewModel;
}

- (void)statusSelected
{
    [self.delegate statusSelected];
}

- (void)updateWithModel:(UserEntity*)model
{
    self.model = model;
}

- (void)setUserModel:(UserEntity*)model
{
    self.model = model;
}

- (NSString*)profession
{
    return self.model.jobTitle;
}

- (NSString*)userName
{
    NSMutableString* userNameWithOld = [NSMutableString string];
    [userNameWithOld insertString:self.model.firstName ? self.model.firstName :@"" atIndex:userNameWithOld.length];
    if (self.model.birthday)
    {
        NSString* old = [NSString stringWithFormat:@", %ld", (long)[FRDateManager userYearFromBirthdayDate:self.model.birthday]];
                          
        [userNameWithOld insertString:old atIndex:userNameWithOld.length];
    }
    return userNameWithOld;
}

- (NSInteger)status
{
    //system_status
    return  0;
}

- (void)updateWallImage:(UIImageView*)wallImage
{
    
    NSString* urlForWallImage = [self.model wallPhoto] ? [self.model wallPhoto] : [self.model coverImage];
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:urlForWallImage]];
    [wallImage sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfArtboard121Canvas] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
        wallImage.image = image;
        
    }];
}

- (void)updateUserPhoto:(UIImageView*)userPhoto
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.userPhoto]];
    UIImage* placeholder = [UIImage new];
    if ([FRUserManager sharedInstance].currentUserPhoto != nil) {
        placeholder = [FRUserManager sharedInstance].currentUserPhoto;
    }
    else
    {
        placeholder = [FRStyleKit imageOfDefaultAvatar];
    }
    [userPhoto sd_setImageWithURL:url placeholderImage:placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [FRUserManager sharedInstance].currentUserPhoto = userPhoto.image;
    }];
}

- (UserEntity*)domainModel
{
    return self.model;
}

- (void)saveSelected
{
    [self.delegate saveSelected];
}
- (void)settingSelected
{
    [self.delegate settingSelected];
}


@end
