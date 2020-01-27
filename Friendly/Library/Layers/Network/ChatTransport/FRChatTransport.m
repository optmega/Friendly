//
//  FRChatTransport.m
//  Friendly
//
//  Created by Sergey on 03.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRChatTransport.h"
#import "FRNetworkManager.h"
#import "FRRoomModel.h"
#import "FRChatRooms.h"
#import "FRPrivatChatResponseModel.h"
#import "FRRoomModel.h"
#import "FRGroupRoom.h"
#import "FRPrivateRoom.h"
#import "FRDateManager.h"
#import "FRPrivateMessage.h"
#import "FRGroupMessage.h"

static NSString* const kRoomPath = @"rooms";
static NSString* const kRoomsPath = @"rooms";
static NSString* const kChatHistoryPath = @"chat/history";

@implementation FRChatTransport

+ (void)createRoomForUserId:(NSString*)userId
                    success:(void(^)(FRRoomModel* room, NSArray* messages))success
                    failure:(void(^)(NSError* error))failure {
    
    if (!userId) {
        return;
    }
    [NetworkManager POST_Path:kRoomPath parameters:@{@"user_id" : userId} success:^(id response) {
        
        NSError* error;
        FRRoomModel* room = [[FRRoomModel alloc]initWithDictionary:response[@"room"] error:&error];
        
        if (room.is_new) {
            id<GAITracker> tracker = APP_DELEGATE.tracker;
            
            [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                                  action:@"Create new chat"
                                                                   label:@""
                                                                   value:nil] build]];
        }
        
        
        NSManagedObjectContext* localContext = [NSManagedObjectContext MR_defaultContext];
        
            FRPrivateRoom* roomPrivate = [FRPrivateRoom createPrivateRoomForId:room.id inContext:localContext];
        
            NSString* opponentId = [[FRUserManager sharedInstance].userId isEqualToString:room.user1_id] ? room.user2_id : room.user1_id;
            
            UserEntity* opponent = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", opponentId] inContext:localContext];
            
            if (opponent) {
                
                roomPrivate.roomTitle = opponent.firstName;
                roomPrivate.opponent = opponent;
            }
        
        [localContext MR_saveToPersistentStoreAndWait];
        
            FRPrivateLastMessage* messages = [[FRPrivateLastMessage alloc] initWithDictionary:response error:&error];
            if (error) {
                if (failure)
                    failure(error);
                return;
            }
            if (success)
                success(room, messages.messages);

        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getRoomsForPage:(NSInteger)page
                success:(void(^)(FRChatRooms* rooms))success
                failure:(void(^)(NSError* error))failure {
    
    NSString* path = [NSString stringWithFormat:@"rooms?page=%ld", (long)page];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FRChatRooms* rooms = [[FRChatRooms alloc] initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        
       
//        NSManagedObjectContext* context = [NSManagedObjectContext MR_context];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
            
            for (FRChatRoom* roomModel in rooms.rooms) {
                FRBaseRoom* room;
                if (roomModel.event_id) {
                    
                    if (roomModel.event)
                        room = [FRGroupRoom groupRoomForId:roomModel.event_id inContext:context];
                    
                    FREvent* entityEvent = [self eventForChat:roomModel.event inContext:context];
                    ((FRGroupRoom*)room).event = entityEvent;
                    
                } else if (roomModel.id) {
                    UserEntity* opponent = [UserEntity initWithUserModel:roomModel.opponent inContext:context];
                    
                    room = [FRPrivateRoom createPrivateRoomForId:roomModel.id inContext:context];
                    room.roomTitle = opponent.firstName;
                    [((FRPrivateRoom*)room) setValue:opponent forKey:@"opponent"];
                }
                
                room.lastActivityAt = [FRDateManager dateFromMessageCreateDateString:roomModel.last_activity];
                
                room.lastMessage = roomModel.last_message.message_text;
                room.lastMessageDate = [FRDateManager dateFromServerWithString:roomModel.last_message.created_at];
                
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
        
            if (success)
                success(rooms);
        }];
        
        
//        [context MR_saveToPersistentStoreAndWait];
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getAllRooms:(void(^)(FRChatRooms* rooms))success
            failure:(void(^)(NSError* error))failure
{
    [self getRoomsForPage:1 success:success failure:failure];
}

+ (void)getMessageForEvent:(NSString *)eventId
                  forPage:(NSInteger)page
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    NSString* path = [NSString stringWithFormat:@"chat/history?event_id=%@&page=%ld", eventId, (long)page];
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FRPrivateLastMessage* messages = [[FRPrivateLastMessage alloc] initWithDictionary:response error:&error];
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
            for (FRPrivateJSONMessage * message in messages.messages) {
                
                [FRGroupMessage createWithModel:message inContext:context];
            }
//        }];
        [context MR_saveToPersistentStoreAndWait];
        
        if (success)
            success(response);
    } failure:^(NSError *error) {
        
        if (failure)
            failure(error);
    }];

    
    
}

+ (void)getMessageForRoom:(NSString *)roomId
                  forPage:(NSInteger)page
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    NSString* path = [NSString stringWithFormat:@"chat/history?room_id=%@&page=%ld", roomId, (long)page];
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FRPrivateLastMessage* messages = [[FRPrivateLastMessage alloc] initWithDictionary:response error:&error];
        if (error) {
            NSLog(@"%@", error);
            return;
        }
        
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        
        NSManagedObjectContext* localContext = [NSManagedObjectContext MR_defaultContext];
            for (FRPrivateJSONMessage * message in messages.messages) {
                
                [FRPrivateMessage createWithModel:message inContext:localContext];
            }
//        }];
        
        [localContext MR_saveToPersistentStoreAndWait];
        
        if (success)
            success(response);
    } failure:^(NSError *error) {
        
        if (failure)
            failure(error);
    }];
    
}

+ (void)getMessageForRoom:(NSString *)roomId
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure
{
    [self getMessageForRoom:roomId forPage:1 success:success failure:failure];
}

/**
     Метод allRooms возвращает не полный ивент.
    Сначала ищем ивент в БД, если его там нет - создаем из полученной модели
 
 */
+ (FREvent*)eventForChat:(FREventModel*)event
               inContext:(NSManagedObjectContext*)context
{
    FREvent* entity = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", event.id] inContext:context];
    if (!entity) {
        entity = [FREvent initWithEvent:event inContext:context];
    }
    
    return entity;
}
@end
