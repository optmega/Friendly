//
//  FRGroupChatResponsModel.h
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRWebSocketConstants.h"

//@interface FRGroupChatResponsModel : JSONModel
//
//@end


@interface FRGroupChatCreatorModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* id;

@end

@interface FRGroupChatDataModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* temp_id;
@property (nonatomic, strong) FRGroupChatCreatorModel<Optional>* creator;
@property (nonatomic, strong) NSString<Optional>* event_id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* msg_text;
@property (nonatomic, assign) FRMessageStatus msg_status;

@end

@interface FRGroupChatResponseModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, assign) FRWSMessageType msg_type;
@property (nonatomic, strong) FRGroupChatDataModel* data;

@end

