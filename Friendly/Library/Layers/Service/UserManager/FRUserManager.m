//
//  FRUserManager.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserManager.h"
#import "UIImageHelper.h"
#import "FRBadgeCountManager.h"
#import "FRStyleKit.h"

@implementation FRUserManager

+ (instancetype)sharedInstance
{
    static FRUserManager* userManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        userManager = [FRUserManager new];
        userManager.canShowAdvertisement = YES;
        userManager.newMessageCount = 0;
        
    });
    
    return userManager;
}

- (BOOL)available_for_meet {
    return [[self currentUser] availableStatus].integerValue;
}
- (NSString*)userId
{
    return [[self currentUser] user_id];
}

- (UIImage*)avatarPlaceholder {
    if (!_avatarPlaceholder){
        _avatarPlaceholder = [FRStyleKit imageOfDefaultAvatar];
    }
    
    return _avatarPlaceholder;
}

- (CurrentUser*)currentUser
{
    CurrentUser* currentUser = [CurrentUser MR_findFirstInContext:[NSManagedObjectContext MR_defaultContext]];
    return currentUser;
}

- (void)udpateFriendsRequest {
    
    [FRBadgeCountManager getFriendsRequest:^(NSInteger count) {
        self.friendsRequestCount = count;
        
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
}

- (UIImage*)logoImage {
    if (!_logoImage) {
        _logoImage = [UIImage imageNamed:@"loader.gif"];
    }
    return  _logoImage;
}

- (UIImage*)normalEventImage {
    if (!_normalEventImage) {
        _normalEventImage = [UIImage imageNamed:@"over-normal-event.png"];
    }
    return _normalEventImage;
}

- (UIImage*)testImage
{
    if(!_testImage)
    {
        _testImage = [UIImage imageNamed:@"imageEvent"];
        _testImage = [UIImageHelper addFilter:_testImage];
    }
    return _testImage;
}

@end
