//
//  FRFriendRequestsCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsCellViewModel.h"
#import "FRUserModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"
#import "FRFriendsListModel.h"

@interface FRFriendRequestsCellViewModel ()

@property (nonatomic, strong) FRFriendlyRequestModel* model;

@end

@implementation FRFriendRequestsCellViewModel

+ (instancetype)initWithModel:(FRFriendlyRequestModel*)model
{
    FRFriendRequestsCellViewModel* viewModel = [FRFriendRequestsCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (void)selectedAccept
{
    id<GAITracker> tracker = APP_DELEGATE.tracker;
    
    [tracker set:kGAIScreenName value:@"FriendsRequests"];
    [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                          action:@"touch"
                                                           label:@"Accept friend"
                                                           value:nil] build]];
    [self.delegate selectedAccept:self];
}

- (void)selectedDecline
{
    [self.delegate selectedDecline:self];
}

- (void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.delegate showUserProfileWithUserId:self.userId];
}

- (void)updatePhotoImage:(UIImageView*)imageView
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.friend.photo]];
    
    [imageView sd_setImageWithURL:url placeholderImage:[FRUserManager sharedInstance].avatarPlaceholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       
        if (image) {
            
            imageView.image = image;
        } else {
            imageView.image = [FRUserManager sharedInstance].avatarPlaceholder;
        }
        
    }];
}

- (NSString*)requestId
{
    return self.model.id;
}

- (NSString*)title
{
    NSMutableString* userNameWithOld = [NSMutableString string];
    [userNameWithOld insertString:self.model.friend.first_name ? self.model.friend.first_name :@"" atIndex:userNameWithOld.length];
    if (self.model.friend.birthday)
    {
        NSString* old = [NSString stringWithFormat:@", %ld", (long)[FRDateManager userYearFromBirthday:self.model.friend.birthday]];
        
        [userNameWithOld insertString:old atIndex:userNameWithOld.length];
    }
    return userNameWithOld;

}

- (NSString*)subtitle
{
    return [NSString stringWithFormat:@"%.1fkm away", [self.model.friend.way integerValue] / 1000.];
}

- (BOOL)isBusy
{
    return [self.model.friend.system_status integerValue] == FRSystemStatusBusy;
}

- (NSString*)userId
{
    return self.model.friend.id;
}

@end

