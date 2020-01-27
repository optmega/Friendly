//
//  FRSettitngDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 13.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSettingDomainModel.h"


static const struct
{
    __unsafe_unretained NSString *group_chat_messages;
    __unsafe_unretained NSString *event_invites;
    __unsafe_unretained NSString *friend_requests;
    __unsafe_unretained NSString *event_requests;
    __unsafe_unretained NSString *user_name;
    __unsafe_unretained NSString *private_account;
    
} FRSettingParametrs =
{
    .group_chat_messages = @"group_chat_messages",
    .event_invites       = @"event_invites",
    .friend_requests     = @"friend_requests",
    .event_requests      = @"event_requests",
    .user_name           = @"first_name",
    .private_account     = @"private_account",
};


@implementation FRSettingDomainModel

- (NSDictionary*)domainModelDictionary
{
    return @{ FRSettingParametrs.group_chat_messages : @(self.group_chat_messages),
                    FRSettingParametrs.event_invites : @(self.event_invites),
                  FRSettingParametrs.friend_requests : @(self.friend_requests),
//                        FRSettingParametrs.user_name : [NSObject bs_safeString:self.user_name],
                  FRSettingParametrs.private_account : @(self.private_account),
                   FRSettingParametrs.event_requests : @(self.event_requests),
              };
}

@end


