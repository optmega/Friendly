//
//  FRRecommendedUsersCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersCellViewModel.h"
#import "FRUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"
#import "FRInterestsModel.h"
#import "FRDateManager.h"


@interface FRRecommendedUsersCellViewModel ()

@property (nonatomic, strong) FRUserModel* model;

@end

@implementation FRRecommendedUsersCellViewModel

+ (instancetype)initWithModel:(FRUserModel*)model
{
    FRRecommendedUsersCellViewModel* viewModel = [FRRecommendedUsersCellViewModel new];
    viewModel.model = model;
    return viewModel;
}

- (void)addUser
{
    [self.delegate addUser:self];
}

- (NSString*)username
{
    NSMutableString* userNameWithOld = [NSMutableString string];
    [userNameWithOld insertString:self.model.first_name ? self.model.first_name :@""  atIndex:userNameWithOld.length];
    if (self.model.birthday)
    {
        [userNameWithOld insertString:[NSString stringWithFormat:@", %ld",(long)[FRDateManager userYearFromBirthday:self.model.birthday]] atIndex:userNameWithOld.length];
    }
    
    return userNameWithOld;
}

- (NSString*)userId
{
    return self.model.id;
}

- (NSString*)usersInterests
{
    if (!self.model.interests.count)
    {
        return @"";
    }
    NSMutableString* tag = [NSMutableString string];
    
    [self.model.interests enumerateObjectsUsingBlock:^(FRInterestsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [tag insertString:[NSString stringWithFormat:@"%@, ", obj.title] atIndex:tag.length];
    }];
    return [tag substringWithRange:NSMakeRange(0, tag.length - 2)];
}

- (void)updateUserPhoto:(UIImageView*)imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.photo] placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}


- (FRUserModel*)domainModel
{
    return self.model;
}

- (void)showUserProfile
{
    [self.delegate showUserProfile:self.model.id];
}

@end
