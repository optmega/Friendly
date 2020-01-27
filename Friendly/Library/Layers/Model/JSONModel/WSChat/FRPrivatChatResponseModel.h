//
//  FRPrivatChatResponseModel.h
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRWebSocketConstants.h"



@interface FRPrivateChatCreatorModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* id;

@end

@interface FRPrivateChatDataModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* temp_id;
@property (nonatomic, strong) FRPrivateChatCreatorModel<Optional>* creator;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* msg_text;
@property (nonatomic, strong) NSString<Optional>* room_id;
@property (nonatomic, assign) FRMessageStatus msg_status;

@end

@interface FRPrivatChatResponseModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, assign) FRWSMessageType msg_type;
@property (nonatomic, strong) FRPrivateChatDataModel* data;

@end

@interface FRPrivateJSONMessage : JSONModel

@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, assign) FRMessageStatus message_status;
@property (nonatomic, strong) NSString<Optional>* message_text;
@property (nonatomic, strong) NSString<Optional>* room_id;
@property (nonatomic, strong) NSString<Optional>* temp_id;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* event_id;

@end

@protocol FRPrivateJSONMessage <NSObject>
@end

@interface FRPrivateLastMessage : JSONModel

@property (nonatomic, strong)  NSArray<FRPrivateJSONMessage, Optional>* messages;

@end
