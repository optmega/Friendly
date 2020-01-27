//
//  FRAppDependencies.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAppDependencies.h"
#import "FRRootWireframe.h"
#import "FRDebugVC.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "FRUserManager.h"
#import "FRPushNotificationManager.h"

#import "FRSettingsTransport.h"

//TODO: temp
//#import "ViewController.h"
#import "FRGlobalHeader.h"

@import GoogleMaps;
@import GooglePlaces;

#import "FRLocationManager.h"
#import "FRDataBaseManager.h"
#import "FRFriendsTransport.h"
#import "FRUserManager.h"
#import "AFNetworkReachabilityManager.h"
#import "FRConnetctionManager.h"
#import "FREventTransport.h"

#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface FRAppDependencies ()

@property (nonatomic, strong) FRRootWireframe* rootWireframe;

@end

@implementation FRAppDependencies

- (instancetype)init
{
    self = [super init];
    if (self)
    {
       self.rootWireframe = [FRRootWireframe new];
    }
    
    return self;
}

- (void)setWindow:(UIWindow *)window
{    
    _window = window;
    self.rootWireframe.window = window;
}

- (void)handleApplicationStart:(UIApplication*)application options:(NSDictionary*)options
{
    
    [[FRLocationManager sharedInstance] startUpdateLocationManager];
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [FRConnetctionManager shared];
    
    [MagicalRecord setupCoreDataStackWithStoreNamed:@"ChatModel"];
    [FRDataBaseManager cleanOldEventRooms];
    [FRDataBaseManager removeOldEvent];
    [FRDataBaseManager removeEventWithFlagIsDelete];
    [FRDataBaseManager shared];

    [FRPushNotificationManager sharedInstance];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
   
    NSString* location = [[NSUserDefaults standardUserDefaults] bs_objectForKey:kLocalization];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:options];
    
    FRLocalizationSetLanguage(location);
    [GMSServices provideAPIKey:GOOGLE_MAP_API];
    [GMSPlacesClient provideAPIKey:GOOGLE_MAP_API];

    UIUserNotificationSettings* set = [UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil];
    
    [application registerUserNotificationSettings:set];
    
#ifdef DEBUG_CONTROLLER
    
    FRDebugVC* debugVC = [FRDebugVC new];
    [self.rootWireframe showRootViewController:debugVC inWindow:self.window];
    
#else
    if (([FRUserManager sharedInstance].currentUser)&&(![[FRUserManager sharedInstance].currentUser.whyAreYouHere isEqualToString:@""]))
    {
        [self.rootWireframe showHomeController:self.window];
    }
    else
    {
        [self.rootWireframe showIntroController:self.window];
    }

#endif

    [self.window makeKeyAndVisible];
    
}

- (void)handleApplicationDidBecomeActive:(UIApplication *)application
{
    [FBSDKAppEvents activateApp];
}

- (void)handleApplicationRegisterForNotificationsWithToken:(NSData*)token
{
    NSLog(@"My token is: %@", token);
    
    NSString *tokenString = [[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    tokenString = [tokenString stringByReplacingOccurrencesOfString:@" " withString:@""];
    [FRUserManager sharedInstance].apnsToken = tokenString;
    
}

- (void)handleOpenUrl:(NSURL *)url {
    [[FRPushNotificationManager sharedInstance] handleOpenUrl:url];
}

- (void)handleApplication:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    [FRUserManager sharedInstance].apnsToken = @"";
    NSLog(@"Error  --- %@", error.localizedDescription);
}

- (void)handleApplication:(UIApplication *)application receiveNotification:(NSDictionary*)notification
{
    NSLog(@"Received notification: %@", notification);
    
    if ( application.applicationState == UIApplicationStateInactive || application.applicationState == UIApplicationStateBackground  ){

        [[FRPushNotificationManager sharedInstance] handleNotification:notification];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
    if (application.applicationState == UIApplicationStateActive)
    {
        [[FRPushNotificationManager sharedInstance] handleNotificationActiveState:notification];
    }
}

- (void)handleApplicationWillBecomeActive:(UIApplication *)application
{

}

- (BOOL)handleApplication:(UIApplication*)application OpenURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
    
}

#pragma mark - Apple Watch

- (void)handleApplication:(UIApplication *)application withWatchKitExtensionRequest:(NSDictionary *)userInfo
{
    
}


@end
