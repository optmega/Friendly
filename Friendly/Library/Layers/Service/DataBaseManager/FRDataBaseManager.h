//
//  FRDataBaseManager.h
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRUserModel;
@class FRPrivateRoom, FRGroupRoom, FRBaseMessage;

static NSString* const kReciveNewMessages = @"kReciveNewMessages";
static NSString* const kUpdateMessageStatus = @"kUpdateMessageStatus";

#import "FRWebSoketManager.h"

@interface FRDataBaseManager : NSObject 

+ (instancetype)shared;
+ (void)synchronizeMessages;

- (void)sendMessage:(NSString*)message toUser:(UserEntity*)user roomId:(NSString*)roomId;
- (void)sendMessage:(NSString*)message toRoom:(FRPrivateRoom*)privateRoom;
- (void)sendMessage:(NSString*)message toGroupRoom:(FRGroupRoom*)groupRoom;

+ (void)updateGroupRoomWithEventID:(NSString*)eventId;
+ (void)updateStatusToReadMessages:(NSArray<FRBaseMessage *>*)messages;
+ (void)cleanOldEventRooms;
+ (void)removeOldEvent;
+ (void)removeEventWithFlagIsDelete;

+ (void)readMessage:(FRBaseMessage*)message;
+ (void) updateNewMessageCount;
+ (void)updatePrivateRoomMessages:(NSArray*)array;
+ (void)uploadEvent;
+ (void)updateEvent;
@end
