//
//  Setting.m
//  Friendly
//
//  Created by Sergey on 07.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "Setting.h"

@implementation Setting

// Insert code here to add functionality to your managed object subclass
- (BOOL)isEqualToSetting:(Setting *)setting
{
    return ([self.groupMessagesNotification isEqual:setting.groupMessagesNotification] &&
            [self.firstName isEqualToString:setting.firstName] &&
            [self.eventInvites isEqual:setting.eventInvites] &&
            [self.friendRequests isEqual:setting.friendRequests] &&
            [self.eventRequests isEqual:setting.eventRequests] &&
            [self.privateAccount isEqual:setting.privateAccount]);
}

@end
