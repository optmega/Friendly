//
//  FRUserProfileHeaderCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 30.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileHeaderCellViewModel.h"
#import "FRUserModel.h"
#import "FRDateManager.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FRUserProfileHeaderCellViewModel ()

@property (nonatomic, strong) UserEntity* model;

@end

@implementation FRUserProfileHeaderCellViewModel

+ (instancetype)initWithModel:(UserEntity*)model
{
    FRUserProfileHeaderCellViewModel* viewModel = [FRUserProfileHeaderCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (void)updateWithModel:(UserEntity*)model
{
    [self setUserModel:model];
}

- (void)setUserModel:(UserEntity*)model
{
    self.model = [[NSManagedObjectContext MR_defaultContext] objectWithID:model.objectID];
}

- (NSString*)profession
{
    return self.model.jobTitle;
}

- (void)backSelected
{
    [self.delegate backSelected];
}

- (NSString*)userName
{
    NSMutableString* userNameWithOld = [NSMutableString string];
    [userNameWithOld insertString:[self.model firstName] ? [self.model firstName] : @"" atIndex:userNameWithOld.length];
    if ([self.model birthday])
    {
        NSString* old = [NSString stringWithFormat:@", %ld", (long)[FRDateManager userYearFromBirthdayDate:[self.model birthday]]];
        
        [userNameWithOld insertString:old atIndex:userNameWithOld.length];
    }
    return userNameWithOld;
}

- (NSString*)away
{
    if (self.model.way.floatValue > 0) {
        return [NSString stringWithFormat:@"%.1fKM AWAY",[self.model.way floatValue]  / 1000.];
    }
    return nil;
}


- (void)updateWallImage:(UIImageView*)wallImage
{
//    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.wall]];
//    [wallImage sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfArtboard121Canvas] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        
//        wallImage.image = !image ? [FRStyleKit imageOfArtboard121Canvas] : image;
//        
//    }];
}

- (void)updateUserPhoto:(UIImageView*)userPhoto
{
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.userPhoto]];
    [userPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}

- (UserEntity*)domainModel
{
    return self.model;
}

- (FRFriendActionMode)friendMode
{
    switch ([self.model.isFriend integerValue]) {
        case 0:
        {
            return FRFriendActionModeAddFriend;
        } break;
            
        case 1:
        {
            return FRFriendActionModePending;
        } break;
            
        case 2:
        {
            return FRFriendActionModeFriend;
        } break;
            
        default:
            break;
    }
    
    return FRFriendActionModeFriend;
}


- (void)saveSelected
{
    [self.delegate saveSelected];
}

- (void)settingSelected
{
    [self.delegate settingSelected:self.model.user_id];
}

- (void)pendingSelected
{
    [self.delegate pendingSelected:self.model.user_id];
}

- (void)addFriendSelected
{
    self.model.isFriend =  @(FRFriendActionModePending);
    [self.delegate addFriendSelected:self.model.user_id];
}

- (void)inviteToEventSelected
{
    [self.delegate inviteToEventSelected:self.model.user_id];
}

- (void)friendsSelected
{
    [self.delegate friendsSelected:self.model.user_id];
}

- (void)dealloc {
    
}
@end
