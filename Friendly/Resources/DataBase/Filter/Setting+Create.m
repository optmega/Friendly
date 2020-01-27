//
//  Setting+Create.m
//  Friendly
//
//  Created by Sergey on 07.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "Setting+Create.h"

@implementation Setting (Create)

+ (instancetype)initWithSetting:(FRSettingModel*)setting inContext:(NSManagedObjectContext *)context{
    
    Setting* settingEntity = [Setting MR_findFirstInContext:context];
    if (!settingEntity) {
        settingEntity = [Setting MR_createEntityInContext:context];
    }
    
    settingEntity.groupMessagesNotification = @(setting.group_chat_messages);
    settingEntity.firstName = setting.first_name;
    settingEntity.eventInvites = @(setting.event_invites);
    settingEntity.friendRequests = @(setting.friend_requests);
    settingEntity.eventRequests = @(setting.event_requests);
    settingEntity.privateAccount = @(setting.private_account);
    
    return  settingEntity;
}

@end
