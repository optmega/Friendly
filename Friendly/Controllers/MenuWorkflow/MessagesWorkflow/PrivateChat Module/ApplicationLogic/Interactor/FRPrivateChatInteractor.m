//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatInteractor.h"
#import "FRDataBaseManager.h"
#import "FRPrivateRoom.h"
#import "FRPrivateMessage.h"
#import "FRUserModel.h"
#import "FRDataBaseManager.h"
#import "UIImageView+WebCache.h"
#import "FRChatTransport.h"
#import "FRRoomModel.h"
#import "FRGroupRoom.h"
#import "FRGroupMessage.h"
#import "FRLocationManager.h"
#import "FRSettingsTransport.h"
#import "FRRequestTransport.h"
#import "FREventTransport.h"

@interface FRPrivateChatInteractor ()

@property (nonatomic, assign) NSInteger fetchOffset;
@property (nonatomic, strong) FREvent* eventForChat;
@property (nonatomic, strong) FRGroupRoom* room;


@end

static NSInteger const kFetchLimit = 30;

@implementation FRPrivateChatInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedMessage:) name:kReciveNewMessages object:nil];
        self.fetchOffset = 0;
        
        
    }
    return self;
}
- (void)deleteEvent {
    [self.output showHudWithType:FRPrivateChatHudTypeShowHud title:nil message:nil];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
       
        [FREventTransport deleteEventWithId:self.eventForChat.eventId success:^{
        } failure:^(NSError *error) {
        }];

        
        [self.eventForChat.groupRoom MR_deleteEntity];
        [self.eventForChat MR_deleteEntity];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self.output showHudWithType:FRPrivateChatHudTypeHideHud title:nil message:nil];
        [self.output backSelected];
    }];
}

- (void)leaveEvent {

    [self.output showHudWithType:FRPrivateChatHudTypeShowHud title:nil message:nil];
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
      
        
        [FRRequestTransport unsubscribeWithEventId:self.eventForChat.eventId success:^{
            
        } failure:^(NSError *error) {}];
        
        
        [self.eventForChat.groupRoom MR_deleteEntity];
        [self.eventForChat MR_deleteEntity];
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [self.output showHudWithType:FRPrivateChatHudTypeHideHud title:nil message:nil];
        [self.output backSelected];
    }];
    
}


- (void)loadChatForEvent:(FREvent*)event
{
    
    [FRChatTransport getMessageForEvent:self.roomId forPage:1 success:^(id success) {
    } failure:^(NSError *error) {
    }];
    
    self.eventForChat = event;
    self.room = [event groupRoom];
    [self loadMessageForEventId:[event eventId]];
        
    [FRUserManager sharedInstance].currentChatGroupId = [event eventId];
}

- (void)sendMessage:(NSString*)textMessage
{
    [[FRDataBaseManager shared] sendMessage:textMessage toGroupRoom:[self.eventForChat groupRoom]];
}

- (void)loadOldMessages:(NSInteger)count
{
    NSInteger page = count / 25 + 1;
    
    [FRChatTransport getMessageForEvent:self.roomId forPage:page success:^(id success) {
        [self.output oldMessageLoaded];
    } failure:^(NSError *error) {
        [self.output oldMessageLoaded];
    }];
    
}

- (void)userEntityForId:(NSString*)userId {
    [self.output showHudWithType:FRPrivateChatHudTypeShowHud title:nil message:nil];
    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
    
    if(!user) {
        [FRSettingsTransport profileFofUserId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
            
            UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
            [self.output showHudWithType:FRPrivateChatHudTypeHideHud title:nil message:nil];
            [self.output selectUser:user];
            
        } failure:^(NSError *error) {
            [self.output showHudWithType:FRPrivateChatHudTypeError title:@"Error" message:error.localizedDescription];
        }];
    } else {
        [self.output showHudWithType:FRPrivateChatHudTypeHideHud title:nil message:nil];
        [self.output selectUser:user];
    }
    
}

- (void)loadMessageForEventId:(NSString*)eventId
{
    self.roomId = eventId;
    
    NSPredicate *messageFilter = [NSPredicate predicateWithFormat:@"eventId == %@", eventId];
    NSFetchRequest *messageRequest = [FRGroupMessage MR_requestAllWithPredicate:messageFilter];
    
    messageRequest.fetchLimit = kFetchLimit;
    messageRequest.fetchOffset = self.fetchOffset;
    
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    [messageRequest setSortDescriptors:@[sort]];
    
    NSArray* message = [FRGroupMessage MR_executeFetchRequest:messageRequest];
    message = [message sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]]];
    
    [self.output updateMessageData:message];
    
    
}

- (NSArray*)notReadArray:(NSArray*)notReadMessages
{
    NSArray* array = [notReadMessages filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"messageStatus != %d AND creatorId != %@", FRMessageStatusRead, [[FRUserManager sharedInstance] userId]]];
    [FRDataBaseManager updateStatusToReadMessages:array];
    
    return array;
}

- (void)loadMessageForId:(NSString*)roomId
{
    self.roomId = roomId;
    self.room.isNewMessage = @(false);
    NSPredicate *messageFilter = [NSPredicate predicateWithFormat:@"roomId == %@", roomId];
    NSFetchRequest *messageRequest = [FRPrivateMessage MR_requestAllWithPredicate:messageFilter];

    messageRequest.fetchLimit = kFetchLimit;
    messageRequest.fetchOffset = self.fetchOffset;
    
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:NO];
    [messageRequest setSortDescriptors:@[sort]];
    
    NSArray* message = [FRPrivateMessage MR_executeFetchRequest:messageRequest];
    message =  [message sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"createDate" ascending:YES]]];
    
    [self notReadArray:message];
   
    [self.output updateMessageData:message];
    
    [FRChatTransport getMessageForRoom:roomId success:^(id result) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)recivedMessage:(NSNotification*)sender
{
    BSDispatchBlockToBackgroundQueue(^{
        
        if ([sender.object isKindOfClass:[FRPrivateMessage class]])
        {
            FRPrivateMessage* privateMessage = sender.object;
            if (privateMessage.room.roomId.integerValue == self.roomId.integerValue)
            {
                privateMessage.room.isNewMessage = false;
                [self _recivedMessage:privateMessage];
            }
        }
        else if ([sender.object isKindOfClass:[FRGroupMessage class]])
        {
            FRGroupMessage* groupMessage = sender.object;
            if ([groupMessage.room.eventId isEqualToString: [self.eventForChat eventId]])
            {
                groupMessage.room.isNewMessage = false;
                [self _recivedMessage:groupMessage];
            }
        }
    });
    
}

- (void)_recivedMessage:(FRBaseMessage*)message
{
    BSDispatchBlockToMainQueue(^{
        [self.output recivedMessage:message];
    });
    if (message.creatorId.integerValue != [FRUserManager sharedInstance].userId.integerValue)
    {
        [FRDataBaseManager updateStatusToReadMessages:@[message]];
    }
}

- (void)shareLocation
{
//    if ([[FRLocationManager sharedInstance] verifiLocationManager])
//    {
        CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
        if (location.latitude || location.latitude)
        {
            NSString* locationMessage = [NSString stringWithFormat:@"{\"MyLocation\": { \"lat\":%f, \"lon\":%f }}", location.latitude, location.longitude];
            [self sendMessage:locationMessage];
            [self.output locationShared:locationMessage];
        }
//    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [FRUserManager sharedInstance].openRoomId = nil;
    [FRUserManager sharedInstance].currentChatGroupId = nil;
    self.room.isNewMessage = @(false);
}

@end
