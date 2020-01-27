//
//  FRAppDependencies.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface FRAppDependencies : NSObject

@property (nonatomic, weak) UIWindow* window;


#pragma mark - Application Lifecycle


- (void)handleApplicationStart:(UIApplication*)application options:(NSDictionary*)options;
- (void)handleApplicationWillBecomeActive:(UIApplication*)application;
- (BOOL)handleApplication:(UIApplication*)application OpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation;
- (void)handleApplicationDidBecomeActive:(UIApplication *)application;

#pragma mark - Notifications

- (void)handleApplicationRegisterForNotificationsWithToken:(NSData*)token;
- (void)handleApplication:(UIApplication*)application receiveNotification:(NSDictionary*)notification;
- (void)handleApplication:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error;
- (void)handleOpenUrl:(NSURL*)url;
#pragma mark - External Actions

- (BOOL)handleOpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;

#pragma mark - Apple Watch

- (void)handleApplication:(UIApplication *)application withWatchKitExtensionRequest:(NSDictionary *)userInfo;


@end
