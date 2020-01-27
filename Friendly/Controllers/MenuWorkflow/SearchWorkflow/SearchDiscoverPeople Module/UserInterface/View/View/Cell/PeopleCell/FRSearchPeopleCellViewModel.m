//
//  FRSearchPeopleCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchPeopleCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRSearchUserModel.h"
#import "FRDateManager.h"
#import "FRStyleKit.h"

@interface FRSearchPeopleCellViewModel ()

@property (nonatomic, strong) FRSearchUserModel* model;

@end

@implementation FRSearchPeopleCellViewModel

+ (instancetype)initWithModel:(FRSearchUserModel*)model
{
    FRSearchPeopleCellViewModel* viewModel = [FRSearchPeopleCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (void)updateUserPhoto:(UIImageView*)userPhoto
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.photo]];
    
    [userPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            userPhoto.image = image;
        }
        else
        {
            userPhoto.image =  [FRStyleKit imageOfDefaultAvatar];
        }
    }];
}

- (NSInteger)isFriend
{
    return [self.model.is_friend integerValue];
}

- (NSArray*)instagramPhotos
{
    if ([[[FRUserManager sharedInstance] currentUser] instagram_id] != nil) {
        
        return self.model.instagram_images;
    }
    
    return nil;
}

- (NSString*)userName
{
    NSMutableString* userNameWithOld = [NSMutableString string];
    [userNameWithOld insertString:self.model.first_name ? self.model.first_name :@"" atIndex:userNameWithOld.length];
    if (self.model.birthday)
    {
        NSString* old = [NSString stringWithFormat:@", %ld", (long)[FRDateManager userYearFromBirthday:self.model.birthday]];
        
        [userNameWithOld insertString:old atIndex:userNameWithOld.length];
    }
    return userNameWithOld;
}

- (NSString*)away
{
    CGFloat away = [self.model.way floatValue] / 1000.;
    return [NSString stringWithFormat:@"%.1fkm away", away];
}

- (NSAttributedString*)commonFriendsOrTag
{
    NSString* mutual = [NSString stringWithFormat:@"Has %lu mutual friends on Facebook", (unsigned long)self.model.mutual_friends.count];
    NSMutableAttributedString* attrMutual = [[NSMutableAttributedString alloc] initWithString:mutual];
    NSString* tempString = [NSString stringWithFormat:@"%lu mutual", (unsigned long)self.model.mutual_friends.count];
    
    NSRange range = [mutual rangeOfString:tempString];
    
    [attrMutual addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
//    return [[NSAttributedString alloc]initWithString:mutual];
    return attrMutual;
}

- (void)profileSelected
{
    [self.delegate profileSelectedWithUserId:self.model.id];
}

- (void)addSelected
{
    [self.delegate addSelectedWithUserId:self.model.id];
}

- (void)friendsSelected
{
    [self.delegate friendsSelectedWithUserId:self.model.id];
}


@end
