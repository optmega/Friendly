//
//  FRDataBaseManager.m
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRDataBaseManager.h"
#import "FRWebSocketTransport.h"
#import "FRWSPrivateRequestDomainModel.h"
#import "FRPrivatChatResponseModel.h"

#import "FRPrivateMessage.h"
#import "FRPrivateMessage+Create.h"
#import "FRPrivateRoom.h"
#import "FRUserModel.h"
#import "FRDateManager.h"
#import "FRGroupRoom.h"
#import "FRWSGroupRequestDomainModel.h"
#import "FRGroupChatResponsModel.h"
#import "FRGroupMessage.h"

#import "FRUserManager.h"
#import "FREventTransport.h"
#import "FRUpdateMessageStatusModel.h"
#import "FREvent.h"
#import "CreateEvent.h"
#import "FREventDomainModel.h"

#import "FRRequestTransport.h"
#import "FRUploadImage.h"
#import "UIImageHelper.h"

#import "FRUploadManager.h"
#import "FRSettingsTransport.h"


static NSString* const kRoomId = @"roomId";

@interface FRDataBaseManager()

@property (nonatomic, strong) NSOperationQueue* saveQueue;

@end

@implementation FRDataBaseManager

+ (instancetype)shared
{
    static dispatch_once_t onceToken;
    static FRDataBaseManager* dataManager = nil;
    dispatch_once(&onceToken, ^{
        dataManager = [FRDataBaseManager new];
    });
    
    return dataManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.saveQueue = [[NSOperationQueue alloc] init];
        self.saveQueue.maxConcurrentOperationCount = 1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedMessage:) name:kWSManagerMessageRecieved object:nil];
    }
    return self;
}

+ (void)synchronizeMessages
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        NSArray* sync = [FRPrivateMessage MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"messageStatus == %@", @(FRMessageStatusCreated)] inContext: context];
        [sync enumerateObjectsUsingBlock:^(FRPrivateMessage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            FRWSPrivateRequestDomainModel* request = [FRWSPrivateRequestDomainModel initWithModel:obj];
            [FRWebSocketTransport sendMessage:[request getJSONString]];
        }];
    }];
    
    
}

- (void)recivedMessage:(NSNotification*)data
{
    NSDictionary* model = data.object;
    
    switch ([model[@"msg_type"] integerValue]) {
        case  FRWSMessageTypeGroupChat:
        {
            [self _recivedGroupMessage:model];
        } break;
        case FRWSMessagePrivateChat:
        {
            [self _recivedPrivateMessage:model];
        } break;
        case FRWSMessageTypeUpdateMsgStatus:
        {
            [self updateStatusMessage:model];
        } break;
        default:
            break;
    }
    
    
    [FRDataBaseManager updateNewMessageCount];

}

- (void)updateStatusMessage:(NSDictionary*)model
{
    NSDictionary* data = model[@"data"];
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    
        FRBaseMessage* message = [FRBaseMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", data[@"msg_id"]] inContext:context];
        message.messageStatus = data[@"msg_status"];
    
//    if ([message isKindOfClass:[FRPrivateMessage class]]) {
//        [(FRPrivateMessage*)message room].lastActivityAt = [NSDate date];
//    } else {
//        [(FRGroupMessage*)message room].lastActivityAt = [NSDate date];
//    }
    
    [context MR_saveToPersistentStoreAndWait];
    
    BSDispatchBlockToMainQueue(^{
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateMessageStatus object:model];
        [FRDataBaseManager updateNewMessageCount];
    });
    
}

- (void)_recivedGroupMessage:(NSDictionary*)groupMessage
{
    
    NSError* error;
    FRGroupChatResponseModel* model = [[FRGroupChatResponseModel alloc] initWithDictionary:groupMessage error:&error];
    if (error) {
        NSLog(@"Error: %@", error.localizedDescription);
        return;
    }
    
    if ([model.data.creator_id integerValue] == [[[FRUserManager sharedInstance].currentUser user_id] integerValue])
    {
        [self _updateMessageAfterGroupResponse:model];
        return;
    }
    
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    
        FRGroupRoom* room = [FRGroupRoom MR_findFirstByAttribute:@"eventId" withValue:model.data.event_id inContext:context];
        if (!room)
        {
            room = [FRGroupRoom MR_createEntityInContext:context];
            room.eventId = model.data.event_id;
        }
        
        if (!room.event) {
            room.event = [FREventTransport getEventForId:model.data.event_id context:context success:^(FREvent *event) {
                event = [context objectWithID:event.objectID];
                room.event = event;
                
            } failure:nil]; 
        }
    
        room.lastActivityAt = [NSDate date];
    
        room.isNewMessage = @(true);
        room.lastUserPhoto = model.data.creator.photo;
        room.currentUserId = [[FRUserManager sharedInstance].currentUser user_id];
        room.lastMessage = [self _lastMessage: model.data.msg_text];
    
        room.lastMessageDate = model.data.created_at.length ? [FRDateManager dateFromMessageCreateDateString:model.data.created_at] : nil;
    
    
    
    FRGroupMessage* newMessage = [FRGroupMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", model.data.id]];
    
    
    if (!newMessage) {
        newMessage = [FRGroupMessage MR_createEntityInContext:context];
    }
    
        [newMessage updateGroupMessage:model];
        newMessage.opponentId = model.data.creator_id;
        newMessage.eventId = room.eventId;
        [room addMessagesObject:newMessage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReciveNewMessages object:newMessage];
        
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
    [context MR_saveToPersistentStoreAndWait];
        
        NSString* str = [NSString stringWithFormat:@"{\"msg_type\": %ld,\"data\": {\"msg_status\": %ld,\"msg_id\": %@}}",(long)FRWSMessageTypeUpdateMsgStatus, (long)FRMessageStatusDelivered, model.data.id];
        
        [[FRWebSoketManager shared]sendMessage:str];
//    }];
    
    
    
}

+ (void)updatePrivateRoomMessages:(NSArray*)array {
    
    
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
        [array enumerateObjectsUsingBlock:^(FRPrivateJSONMessage* model, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([model.creator_id isEqualToString:[[FRUserManager sharedInstance] userId]]) {
                return ;
            }
            FRPrivateRoom* room = [FRPrivateRoom MR_findFirstByAttribute:kRoomId withValue:model.room_id inContext:context];
            if (!room)
            {
                room = [FRPrivateRoom MR_createEntityInContext:context];
                room.roomId = model.room_id;
                
            }
            
            if ([FRDateManager dateForCallFromString:model.created_at] > room.lastMessageDate) {
                room.lastMessage = model.message_text;
            }
            
            room.isNewMessage = [NSNumber numberWithBool:false];
            
            FRPrivateMessage* newMessage = [FRPrivateMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", model.id] inContext:context];
            if (!newMessage) {
                
               newMessage = [FRPrivateMessage MR_createEntityInContext:context];
            }
            
            [newMessage updateLastMessage:model];
            newMessage.opponentId = model.creator_id;
            newMessage.roomId = room.roomId;
            [room addMessagesObject:newMessage];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:kReciveNewMessages object:newMessage];
            
            if ([model.user_id isEqualToString: [FRUserManager sharedInstance].userId] ||
                (model.message_status == FRMessageStatusDelivered ||
                 model.message_status == FRMessageStatusRead)) {
                    return;
                }
           
            
            NSString* str = [NSString stringWithFormat:@"{\"msg_type\": %ld,\"data\": {\"msg_status\": %ld,\"msg_id\": %@}}",(long)FRWSMessageTypeUpdateMsgStatus, (long)FRMessageStatusRead, model.id];
            
            
            [[FRWebSoketManager shared]sendMessage:str];
        }];
    
    [context MR_saveToPersistentStoreAndWait];
//    }];
    
}

- (void)_recivedPrivateMessage:(NSDictionary*)privateMessage
{
    NSError* error;
    
    FRPrivatChatResponseModel* model = [[FRPrivatChatResponseModel alloc] initWithDictionary:privateMessage error:&error];
    if (error)
    {
        return;
    }
    
    if ([model.data.creator_id integerValue] == [[[FRUserManager sharedInstance].currentUser user_id] integerValue])
    {
        [self _updateMessageAfterResponse:model];
        return;
    }
    

        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    
    
        FRPrivateRoom* room = [FRPrivateRoom MR_findFirstByAttribute:kRoomId withValue:model.data.room_id inContext:context];
        if (!room)
        {
            room = [FRPrivateRoom MR_createEntityInContext:context];
            room.roomId = model.data.room_id;
            
        }
    
    room.lastActivityAt = [NSDate date];
        room.isNewMessage = @(true);
        room.currentUserId = [[FRUserManager sharedInstance].currentUser user_id];
        room.opponentName = model.data.creator.first_name;
        room.roomTitle = model.data.creator.first_name;
        room.roomImage = model.data.creator.photo;
    
    if ([FRDateManager dateFromMessageCreateDateString:model.data.created_at] > room.lastMessageDate) {
        
        room.lastMessageDate = [FRDateManager dateFromMessageCreateDateString:model.data.created_at];
    }

    
        room.lastMessage =  [self _lastMessage:model.data.msg_text];
    
    
    FRPrivateMessage* newMessage = [FRPrivateMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", model.data.id] inContext:context];
    if (!newMessage) {
        
        newMessage = [FRPrivateMessage MR_createEntityInContext:context];
    }
    
        [newMessage updatePriveteMessage:model];
        newMessage.opponentId = model.data.creator_id;
        newMessage.roomId = room.roomId;
        [room addMessagesObject:newMessage];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReciveNewMessages object:newMessage];
    
        if (![room opponent]) {
            
            UserEntity* opponent = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",newMessage.opponentId] inContext:context];
            
            if (!opponent) {
                opponent = [UserEntity MR_createEntityInContext:context];
                opponent.user_id = newMessage.opponentId;
                opponent.firstName = room.opponentName;
                opponent.userPhoto = room.roomImage;
            }
            
            room.opponent = opponent;
            
        }
//    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
    
    [context MR_saveToPersistentStoreAndWait];
    
        model.msg_type = FRWSMessageTypeUpdateMsgStatus;
        model.data.msg_status = FRMessageStatusDelivered;
        
        NSString* str = [NSString stringWithFormat:@"{\"msg_type\": %ld,\"data\": {\"msg_status\": %ld,\"msg_id\": %@}}",(long)FRWSMessageTypeUpdateMsgStatus, (long)FRMessageStatusDelivered, model.data.id];
        
        [[FRWebSoketManager shared]sendMessage:str];
//    }];
    
}

+ (void)updateNewMessageCount {
    NSArray* allMessage = [FRGroupMessage MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(messageStatus = %@ || messageStatus == %@) && creatorId != %@ && room != NIL", @(FRMessageStatusDelivered), @(FRMessageStatusSend), [FRUserManager sharedInstance].userId]];
    
    
    NSArray* allPrivateMessage = [FRPrivateMessage MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"(messageStatus = %@ || messageStatus == %@) && creatorId != %@ && room != NIL", @(FRMessageStatusDelivered), @(FRMessageStatusSend), [FRUserManager sharedInstance].userId]];
    
    BSDispatchBlockToMainQueue(^{
        
        [[FRUserManager sharedInstance] setNewMessageCount:allMessage.count + allPrivateMessage.count];
    });
}

+ (void)updateStatusToReadMessages:(NSArray<FRBaseMessage *>*)messages
{
    BSDispatchBlockToBackgroundQueue(^{
        
        [messages enumerateObjectsUsingBlock:^(FRBaseMessage*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            obj = [[NSManagedObjectContext MR_defaultContext] objectWithID:obj.objectID];
            
            if ([obj messageId] && ![[obj creatorId] isEqualToString:[FRUserManager sharedInstance].userId]) {
                
                
                FRUpdateMessageStatusModel* updateModel = [FRUpdateMessageStatusModel new];
                updateModel.type = FRWSMessageTypeUpdateMsgStatus;
                updateModel.status = FRMessageStatusRead;
                updateModel.messageId = [obj messageId];
                
                [[FRWebSoketManager shared]sendMessage:[updateModel getJSONString]];
            }
            
        }];
    });
}

+ (void)readMessage:(FRBaseMessage*)message {
    
    FRUpdateMessageStatusModel* updateModel = [FRUpdateMessageStatusModel new];
    updateModel.type = FRWSMessageTypeUpdateMsgStatus;
    updateModel.status = FRMessageStatusRead;
    updateModel.messageId = [message messageId];
    
    [[FRWebSoketManager shared]sendMessage:[updateModel getJSONString]];
}

- (void)sendMessage:(NSString*)message toGroupRoom:(FRGroupRoom*)groupRoom
{
    [self _sendMessage:message groupRoom:groupRoom];
}

- (void)sendMessage:(NSString*)message toRoom:(FRPrivateRoom*)privateRoom
{
    NSString* roomId = [NSString stringWithFormat:@"%@",privateRoom.roomId];
    NSString* opponentName = privateRoom.opponentName;
    NSString* roomImage = privateRoom.roomImage;
    NSDate* opponentBirthday = privateRoom.opponentBirthday;
    
    [self _sendMessage:message
                roomId:roomId
                userId:privateRoom.userId
          opponentName:opponentName
             roomImage:roomImage
      opponentBirthday:opponentBirthday];
}

- (void)sendMessage:(NSString*)message toUser:(UserEntity*)user roomId:(NSString*)roomId
{
    [self _sendMessage:message
                roomId:roomId
                userId:user.user_id
          opponentName:user.firstName
             roomImage:user.userPhoto
      opponentBirthday:user.birthday];
}


#pragma mark - private

- (void)_updateMessageAfterGroupResponse:(FRGroupChatResponseModel*)model
{
    __block FRGroupMessage* message;
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tempId == %@ && creatorId == %@", model.data.temp_id, model.data.creator_id];
        
        message = [FRGroupMessage MR_findFirstWithPredicate:predicate inContext:context];
        [message updateGroupMessage:model];
        
        FRGroupRoom* room = [message room];
        
        if (message.createDate > room.lastMessageDate) {
            
            room.lastMessageDate = message.createDate;
        }
        
        
        
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kReciveNewMessages object:message];

    }];
    
}


- (void)_updateMessageAfterResponse:(FRPrivatChatResponseModel*)model
{
    __block FRPrivateMessage* message;
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"tempId == %@ && creatorId == %@", model.data.temp_id, model.data.creator_id];
        
        message = [FRPrivateMessage MR_findFirstWithPredicate:predicate inContext:context];
        [message updatePriveteMessage:model];
        
        FRPrivateRoom* room = message.room;
//        room.lastMessage = [self _lastMessage:message.messageText];
        
        
        if (message.createDate > room.lastMessageDate) {
            
            room.lastMessageDate = message.createDate;
        }
        
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        [[NSNotificationCenter defaultCenter] postNotificationName:kReciveNewMessages object:message];
    }];
    
}

- (void)_sendMessage:(NSString*)message groupRoom:(FRGroupRoom*)groupRoom
{
    FRWSGroupRequestDomainModel* request = [self _createGroupRequestWithMessage:message toGroupRoom:groupRoom];
    
    NSError* error;
    FRGroupChatResponseModel* requestModel = [[FRGroupChatResponseModel alloc] initWithDictionary:[request domainModelDictionary]  error:&error];
    if (error)
    {
        NSLog(@"%@", error.localizedDescription);
    }
    requestModel.data.creator_id = [[FRUserManager sharedInstance].currentUser user_id];
    
    groupRoom.lastMessage = [self _lastMessage:message];
    groupRoom.lastUserPhoto = [[FRUserManager sharedInstance].currentUser userPhoto];
    groupRoom.lastMessageDate = [NSDate date];
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        FRGroupMessage* messageDB = [FRGroupMessage MR_createEntityInContext:context];
        [messageDB updateGroupMessage:requestModel];
        
        [FRWebSocketTransport sendMessage:[request getJSONString]];
    }];
    
    
}

- (void)_sendMessage:(NSString*)message
              roomId:(NSString*)roomId
              userId:(NSString*)userId
        opponentName:(NSString*)opponentName
           roomImage:(NSString*)roomImage
    opponentBirthday:(NSDate*)opponentBirthday
{
    FRWSPrivateRequestDomainModel* request = [self _createRequestWithMessage:message toUserId:userId roomId:roomId];
    
    NSError* error;
    FRPrivatChatResponseModel* requestModel = [[FRPrivatChatResponseModel alloc] initWithDictionary:[request domainModelDictionary] error:&error];
    requestModel.data.creator_id = [[FRUserManager sharedInstance].currentUser user_id];
    
    
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        
            FRPrivateRoom* room = [FRPrivateRoom MR_findFirstByAttribute:kRoomId withValue:roomId inContext:context];
            if (!room)
            {
                room = [FRPrivateRoom MR_createEntityInContext:context];
                room.roomId = roomId;
            }
            room.lastMessage = [self _lastMessage:message];
            room.opponentName = opponentName;
            room.roomTitle = opponentName;
            room.roomImage = roomImage;
            room.opponentBirthday = opponentBirthday;
            room.lastMessageDate = [NSDate date];
            room.userId = userId;
            room.isNewMessage = @(false);
            
            if (error)
            {
                NSLog(@"%@", error.localizedDescription);
                return;
            }
            
            FRPrivateMessage* messageBD = [FRPrivateMessage MR_createEntityInContext:context];
            [messageBD updatePriveteMessage:requestModel];
            
            messageBD.opponentId = roomId;
            [room addMessagesObject:messageBD];
        
    } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        [FRWebSocketTransport sendMessage:[request getJSONString]];
    }];
}

+ (void)updateGroupRoomWithEventID:(NSString*)eventId
{
    BSDispatchBlockToBackgroundQueue(^{
        
        [FREventTransport getEventInfoWithId:eventId success:^(FREvent *event) {
            
//            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
            NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
                [FRGroupRoom initOrUpdateGroupRoomWithModel:event inContext:context];
//            }];
            
            [context MR_saveToPersistentStoreAndWait];
            
        } failure:^(NSError *error) {
            NSLog(@"Error - %@", error);
        }];
    });
}



- (FRWSGroupRequestDomainModel*)_createGroupRequestWithMessage:(NSString*)message toGroupRoom:(FRGroupRoom*)groupRoom
{
    NSString* text = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    FRWSGroupRequestDomainModel* groupRequest = [FRWSGroupRequestDomainModel new];
    groupRequest.messageType = FRWSMessageTypeGroupChat;
    groupRequest.messageText = text;
    groupRequest.eventId = groupRoom.eventId;
    groupRequest.tempId = [self _tempIdentifier];
    groupRequest.msg_status = FRMessageStatusCreated;
    return groupRequest;
}

- (FRWSPrivateRequestDomainModel*)_createRequestWithMessage:(NSString*)message toUserId:(NSString*)userId roomId:(NSString*)roomId
{
    NSString* text = [message stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    FRWSPrivateRequestDomainModel* privateRequest = [FRWSPrivateRequestDomainModel new];
    privateRequest.messageType = FRWSMessagePrivateChat;
    privateRequest.tempId = [self _tempIdentifier];
    privateRequest.messageText = text;
    privateRequest.userId = userId;
    privateRequest.room_id = roomId;
    privateRequest.messageStatus = FRMessageStatusCreated;
    
    return privateRequest;
}

- (NSString*)_tempIdentifier
{
    long long timeStamp = (long long)([[NSDate date] timeIntervalSince1970]*1000.0);
    return [NSString stringWithFormat:@"%lld", timeStamp];
}

- (NSString*)_lastMessage:(NSString*)message
{
    return  [message containsString:@"{\"MyLocation\": { \"lat\":"] ? @"Location" : message;
}

+ (void)removeOldEvent {
    
   [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
       NSArray* oldEvents = [FREvent MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"isDelete == %@ OR event_start < %@", @(true), [NSDate date]] inContext:context];
       [oldEvents enumerateObjectsUsingBlock:^(FREvent*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           [obj MR_deleteEntityInContext:context];
       }];
   }];
}

+ (void)removeEventWithFlagIsDelete {
  
        [FREventTransport getDeleteEventIdWithSuccess:^(NSArray *eventId) {
            BSDispatchBlockToBackgroundQueue(^{
                
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
               
                for (NSString* evId in eventId) {
                    FREvent* event = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat: @"eventId == %@", evId]];
                        if (event) {
                            [event MR_deleteEntityInContext:context];
                        }
                    }
                }];
            });
            
        } failure:^(NSError *error) {
            
        }];
}

+ (void)cleanOldEventRooms
{
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        NSArray* eventRooms = [FRGroupRoom MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"eventDate < %@", [FRDateManager dateForRemoveEventChat:[NSDate date]]]inContext:context];
        
        [eventRooms enumerateObjectsUsingBlock:^(FRGroupRoom*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"%@\n%@", obj.eventDate, [FRDateManager dateForRemoveEventChat:[NSDate date]]);
            [obj MR_deleteEntityInContext:context];
        }];
    }];
}

+ (void)uploadEvent {
    [FRUploadManager uploadEvent];
}


+ (void)createEvent:(CreateEvent*)ev {
    
    [FRUploadManager uploadEvent];
}

+ (void)updateEvent {
    [FRUploadManager updateEvent];
}

@end
