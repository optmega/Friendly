//
//  FRGroupMessage+Create.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupMessage+Create.h"
#import "FRDateManager.h"
#import "MemberUser.h"

@implementation FRGroupMessage (Create)

- (void)updateGroupMessage:(FRGroupChatResponseModel*)model
{
    self.messageId = model.data.id;
    self.tempId = model.data.temp_id;
    self.userPhoto = model.data.creator.photo;
    self.firstName = model.data.creator.first_name;
    self.messageType = @(model.msg_type);
    self.creatorId = model.data.creator_id;
    self.createDate =  model.data.created_at ? [FRDateManager dateFromMessageCreateDateString: model.data.created_at] : [NSDate date];
    self.userId = model.data.event_id;
    self.messageText = model.data.msg_text;
    self.messageStatus = @(model.data.msg_status);
    self.eventId = model.data.event_id;
}


+ (FRGroupMessage*)createWithModel:(FRPrivateJSONMessage*)model inContext:(NSManagedObjectContext*)context{
    
    FRGroupMessage* message = [FRGroupMessage MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"messageId == %@", model.id] inContext:context];
    
    if (!message) {
        message = [FRGroupMessage MR_createEntityInContext:context];
    }
    [message updateLastMessage:model];
    
    return message;
}


- (void)updateLastMessage:(FRPrivateJSONMessage*)model
{
//    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", model.user_id]];
    
    MemberUser* user = [MemberUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"userId == %@", model.creator_id]];
    
    
    self.messageId = model.id;
    self.tempId = model.temp_id;
    self.userPhoto = user.photo;
    self.firstName = user.firstName;

    self.creatorId = model.creator_id;
    self.createDate = [FRDateManager dateFromMessageCreateDateString: model.created_at];
    self.userId = model.creator_id;
    self.messageText = model.message_text;
    self.messageStatus = @(model.message_status);
    self.eventId = model.event_id;
}


@end
