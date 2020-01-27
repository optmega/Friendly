//
//  FRWSGroupRequestDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 17.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRWSGroupRequestDomainModel.h"
#import "FRGroupMessage.h"

static const struct
{
    __unsafe_unretained NSString *msg_type;
    __unsafe_unretained NSString *data;
    __unsafe_unretained NSString *temp_id;
    __unsafe_unretained NSString *event_id;
    __unsafe_unretained NSString *msg_text;
    __unsafe_unretained NSString *msg_status;
    
} FRWSGroupRequestParametrs =
{
    .msg_type   = @"msg_type",
    .data       = @"data",
    .temp_id    = @"temp_id",
    .event_id   = @"event_id",
    .msg_text   = @"msg_text",
    .msg_status = @"msg_status",
};


@implementation FRWSGroupRequestDomainModel

+ (instancetype)initWithModel:(FRGroupMessage*)model
{
    FRWSGroupRequestDomainModel* domainModel = [self new];
    domainModel.messageType = [model.messageType integerValue];
    domainModel.tempId = model.tempId;
    domainModel.eventId = model.eventId;
    domainModel.messageText = model.messageText;
    
    return domainModel;
}

- (NSDictionary*)domainModelDictionary
{
    NSDictionary* dataDict = @{
                               FRWSGroupRequestParametrs.temp_id : [NSObject bs_safeString:self.tempId],
                              FRWSGroupRequestParametrs.event_id : [NSObject bs_safeString:self.eventId],
                              FRWSGroupRequestParametrs.msg_text : [NSObject bs_safeString:self.messageText],
                            FRWSGroupRequestParametrs.msg_status : @(self.msg_status),
                               };
    
    return @{
             FRWSGroupRequestParametrs.msg_type : @(self.messageType),
                 FRWSGroupRequestParametrs.data : dataDict,
             };
}

@end
