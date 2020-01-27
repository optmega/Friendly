//
//  FRPushNotificationConstants.h
//  Friendly
//
//  Created by Dmitry on 20.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRPushNotificationType) {
    
    FRPushNotificationTypeSomeoneAddsYou = 1,
    FRPushNotificationTypeSomeoneAsksToJoinYourEvent = 2,
    FRPushNotificationTypeSomeoneInvitesYouToAnEvent = 3,
    FRPushNotificationTypeNewMessage = 4,
    FRPushNotificationTypeEventReminder = 5,
    FRPushNotificationTypeNewUser = 6,
    FRPushNotificationTypeSomeoneInvitesYouToAnEventAsCohost = 7,
    FacebookFriendInvitedByYouJoined = 8
};


