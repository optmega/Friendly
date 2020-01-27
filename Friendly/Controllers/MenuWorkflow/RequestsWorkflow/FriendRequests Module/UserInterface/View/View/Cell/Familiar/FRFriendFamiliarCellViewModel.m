//
//  FRFriendFamiliarCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 09.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendFamiliarCellViewModel.h"
#import "FRUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"
#import "FRFriendsListModel.h"


@interface FRFriendFamiliarCellViewModel ()

@property (nonatomic, strong) FRPotentialFriendModel* model;

@end

@implementation FRFriendFamiliarCellViewModel

+ (instancetype)initWithModel:(FRPotentialFriendModel*)model
{
    FRFriendFamiliarCellViewModel* viewModel = [FRFriendFamiliarCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (void)selectedAdd
{
    [self.delegate selectedAdd:self];
}

- (void)selectedRemove
{
    [self.delegate selectedRemove:self];
}

- (void)updatePhotoImage:(UIImageView*)imageView
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.photo]];
    
    [imageView sd_setImageWithURL:url placeholderImage:[FRUserManager sharedInstance].avatarPlaceholder  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image) {
            
            imageView.image = image;
        } else {
            imageView.image = [FRUserManager sharedInstance].avatarPlaceholder;
        }
    }];
}

- (NSString*)title
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

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"%ld %@", (long)self.model.mutuals_count, self.model.mutuals_count > 1 ? FRLocalizedString(@"mutual friends", nil) : FRLocalizedString(@"mutual friend", nil)];
}

- (NSString*)userId
{
    return self.model.user_id;
}

- (BOOL)isBusy
{
    return NO;
}

- (void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.delegate showUserProfileWithEntity:user];
}
@end



