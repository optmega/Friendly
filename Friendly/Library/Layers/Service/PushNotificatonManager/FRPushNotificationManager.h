//
//  FRPushNotificationManager.h
//  Friendly
//
//  Created by Sergey Borichev on 12.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRPushNotificationManager : NSObject

+ (instancetype)sharedInstance;
- (void)handleNotification:(NSDictionary *)userInfo;
- (void)handleNotificationActiveState:(NSDictionary *)userInfo;
- (void)handleOpenUrl:(NSURL*)url;
@end
