//
//  FRMessagesGroupRoomCellViewModel.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagesGroupRoomCellViewModel.h"
#import "FRDateManager.h"
#import "UIImageView+WebCache.h"
#import "FRMemberUser.h"
#import "FRWebSocketConstants.h"
#import "FRStyleKit.h"

@interface FRMessagesGroupRoomCellViewModel ()

@property (nonatomic, strong) FRGroupRoom* model;

@end

@implementation FRMessagesGroupRoomCellViewModel

+ (instancetype)initWithModel:(FRGroupRoom*)model
{
    FRMessagesGroupRoomCellViewModel* domainModel = [FRMessagesGroupRoomCellViewModel new];
    model = [[NSManagedObjectContext MR_defaultContext] objectWithID:model.objectID];
    domainModel.model = model;
    return domainModel;
}

- (void)selectedGroupRoom
{
    [self.delegate selectedGroupRoom:self.model];
}

- (NSString*)name
{
    return [[self.model event] title];
}
- (BOOL)isNewMessage {
    
    FRGroupRoom* room = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.model.objectID];
    NSSet* set = [[room messages] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(messageStatus = %@ || messageStatus == %@) && creatorId != %@", @(FRMessageStatusDelivered), @(FRMessageStatusSend), [FRUserManager sharedInstance].userId]];
    
    
    return [set count];
}
- (NSString*)dayOfWeak
{
    return [[FRDateManager dayOfWeek:[[self.model event] event_start]] uppercaseString];
}

- (NSString*)dayOfMonth
{
    return [[FRDateManager dayOfMonth:[[self.model event] event_start]] uppercaseString];
}

- (void)setLastMessageUserImage:(UIImageView*)imageView
{
//    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:[self.model lastUserPhoto]]] placeholderImage:[FRUserManager sharedInstance].logoImage];
    UserEntity* user = [[self.model event] creator];
    [imageView sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:user.userPhoto]] placeholderImage:[[FRUserManager sharedInstance] avatarPlaceholder]];
}

- (void)updateUserImages:(NSArray*)images
{
    if (!self.model.event)
    {
        return;
    }
    
    for (UIImageView* imageView in images) {
        imageView.hidden = true;
    }
    
        
    FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.model.event.objectID];
    NSArray* memberUsers;
   
    if ([event memberUsers]) {
        return;
    }
    @try {
        
        memberUsers = [[event memberUsers] allObjects];
        
    } @catch (NSException *exception) {
        return;
    } @finally {
    }
    
        [memberUsers enumerateObjectsUsingBlock:^(NSManagedObject * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if (idx >= images.count)
            {
                *stop = YES;
            }
            FRMemberUser* user = (FRMemberUser*)obj;
            UIImageView* iv = [images objectAtIndex:idx];
            NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[user photo]]];
            
            [iv sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                iv.hidden = NO;
            }];
            
        }];

}

- (NSString*)lastMessage
{
    if ([[self.model lastMessage] containsString:@"{\"MyLocation\":"]) {
        return @"Location";
    }
    
    
    return [self.model lastMessage];
}

- (NSString*)date
{
    return  [FRDateManager dateForChatRoomFromDate:[self.model lastMessageDate]];
}

- (FRGroupRoom*)domainModel
{
    return self.model;
}
@end
