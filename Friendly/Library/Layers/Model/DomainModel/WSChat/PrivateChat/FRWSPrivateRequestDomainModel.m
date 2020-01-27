//
//  FRWSPrivateRequestDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 17.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRWSPrivateRequestDomainModel.h"
#import "FRPrivateMessage.h"

static const struct
{
    __unsafe_unretained NSString *msg_type;
    __unsafe_unretained NSString *data;
    __unsafe_unretained NSString *temp_id;
    __unsafe_unretained NSString *user_id;
    __unsafe_unretained NSString *msg_text;
    __unsafe_unretained NSString *msg_status;
    __unsafe_unretained NSString *room_id;
    
} FRWSPrivateRequestParametrs =
{
    .msg_type   = @"msg_type",
    .data       = @"data",
    .temp_id    = @"temp_id",
    .user_id    = @"user_id",
    .msg_text   = @"msg_text",
    .msg_status = @"msg_status",
    .room_id    = @"room_id",
};


@implementation FRWSPrivateRequestDomainModel

+ (instancetype)initWithModel:(FRPrivateMessage*)model
{
    FRWSPrivateRequestDomainModel* domainModel = [FRWSPrivateRequestDomainModel new];
    domainModel.tempId = model.tempId;
    domainModel.userId = [NSString stringWithFormat:@"%@",model.userId];
    domainModel.messageStatus = [model.messageStatus integerValue];
    domainModel.messageText = model.messageText;
    domainModel.messageType = [model.messageType integerValue];
    domainModel.room_id = model.roomId;
    
    return domainModel;
}

- (NSDictionary*)domainModelDictionary
{
    NSDictionary* dataDict = @{
                            FRWSPrivateRequestParametrs.temp_id : [NSObject bs_safeString:self.tempId],
                            FRWSPrivateRequestParametrs.user_id : [NSObject bs_safeString:self.userId],
                           FRWSPrivateRequestParametrs.msg_text : [NSObject bs_safeString:self.messageText],
                            FRWSPrivateRequestParametrs.room_id : [NSObject bs_safeString:self.room_id],
                         FRWSPrivateRequestParametrs.msg_status : @(self.messageStatus),
                               };
    
    return @{
             FRWSPrivateRequestParametrs.msg_type : @(self.messageType),
                 FRWSPrivateRequestParametrs.data : dataDict,
             };
}

@end
