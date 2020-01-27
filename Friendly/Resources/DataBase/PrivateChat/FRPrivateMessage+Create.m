//
//  FRMessage+Create.m
//  Friendly
//
//  Created by Sergey Borichev on 18.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateMessage+Create.h"
#import "FRPrivatChatResponseModel.h"
#import "FRDateManager.h"
#import "FRUserManager.h"


@implementation FRPrivateMessage (Create)

+ (FRPrivateMessage*)createWithModel:(FRPrivateJSONMessage*)model inContext:(NSManagedObjectContext*)context{
    
    FRPrivateMessage* message = [FRPrivateMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", model.id] inContext:context];
    
    if (!message) {
        message = [FRPrivateMessage MR_createEntityInContext:context];
    }
    [message updateLastMessage:model];
    
    return message;
}

- (void)updatePriveteMessage:(FRPrivatChatResponseModel*)model
{
    self.messageId = model.data.id;
    self.tempId = model.data.temp_id;
    self.userPhoto = model.data.creator.photo;
    self.firstName = model.data.creator.first_name;
    self.messageType = @(model.msg_type);
    self.creatorId = model.data.creator_id;
    self.createDate =  model.data.created_at ? [FRDateManager dateFromMessageCreateDateString: model.data.created_at] : [NSDate date];
    self.userId = model.data.user_id;
    self.messageText = model.data.msg_text;
    self.messageStatus = @(model.data.msg_status);
    self.roomId = model.data.room_id;
}

- (void)updateLastMessage:(FRPrivateJSONMessage*)model
{
    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", model.user_id]];
    
    self.messageId = model.id;
    self.tempId = model.temp_id;
    self.userPhoto = user.userPhoto;
    self.firstName = user.firstName;
//    self.messageType = @(model.message_status);
    self.creatorId = model.creator_id;
    self.createDate = [FRDateManager dateFromMessageCreateDateString: model.created_at];
    self.userId = model.user_id;
    self.messageText = model.message_text;
    self.messageStatus = @(model.message_status);
    self.roomId = model.room_id;
}


@end
