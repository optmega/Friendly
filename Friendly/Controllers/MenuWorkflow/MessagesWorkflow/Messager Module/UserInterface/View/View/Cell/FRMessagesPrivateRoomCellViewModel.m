//
//  FRMessagesPrivateRoomCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagesPrivateRoomCellViewModel.h"
#import "FRUserManager.h"
#import "UIImageView+WebCache.h"
#import "FRPrivateRoom.h"
#import "FRDateManager.h"
#import "FRWebSocketConstants.h"
#import "FRStyleKit.h"

@interface FRMessagesPrivateRoomCellViewModel ()

@property (nonatomic, strong) FRPrivateRoom* model;

@end

@implementation FRMessagesPrivateRoomCellViewModel



+ (instancetype)initWithModel:(FRPrivateRoom*)model
{
    FRMessagesPrivateRoomCellViewModel* viewModel = [FRMessagesPrivateRoomCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (void)updatePhoto:(UIImageView*)imageView
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.opponent.userPhoto]];
    
    [imageView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
}

- (NSString*)name
{
    return self.model.opponent.firstName;
}

- (NSString*)lastMessage
{
    if ([[self.model lastMessage] containsString:@"{\"MyLocation\":"]) {
        return @"Location";
    }
    
    return self.model.lastMessage;
}

- (NSString*)date
{
//    + (NSString*)dateForChatRoomFromDate:(NSDate*)date

    return [FRDateManager dateForChatRoomFromDate:self.model.lastMessageDate];
}

- (BOOL)isNewMessage
{

    
    
    if (self.model) 
    self.model =  [[NSManagedObjectContext MR_defaultContext] objectWithID:self.model.objectID];

    
    FRPrivateRoom* room = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.model.objectID];
    NSSet* set = [[room messages] filteredSetUsingPredicate:[NSPredicate predicateWithFormat:@"(messageStatus = %@ || messageStatus == %@) && creatorId != %@", @(FRMessageStatusDelivered), @(FRMessageStatusSend), [FRUserManager sharedInstance].userId]];

    
    return [set count];

}

- (void)selectedRoom
{
    [self.delegate selectedRoom:self.model];
}


@end
