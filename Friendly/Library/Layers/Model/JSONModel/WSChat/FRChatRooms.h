//
//  FRChatRooms.h
//  Friendly
//
//  Created by Dmitry on 27.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRUserModel.h"
#import "FREventModel.h"

@interface FRChatRoomOpponent : FRUserModel

@property (nonatomic, strong) NSString<Optional>* avatar;

@end

@protocol FRChatRoomOpponent <NSObject>
@end

@interface FRChatRoomLastMessage : JSONModel

@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* message_text;
@end
 

@interface FRChatRoom : JSONModel

@property (nonatomic, strong) NSString<Optional>* user1_id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* last_activity_at;

@property (nonatomic, strong) NSString<Optional>* is_system;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* user2_id;

@property (nonatomic, strong) NSString<Optional>* event_id;
@property (nonatomic, strong) NSString<Optional>* last_activity;
@property (nonatomic, strong) FRUserModel<Optional>* opponent;
@property (nonatomic, strong) FREventModel<Optional>* event;
@property (nonatomic, strong) FRChatRoomLastMessage<Optional>* last_message;
@end


@protocol FRChatRoom <NSObject>
@end

@interface FRChatRooms : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRChatRoom>* rooms;
@end
