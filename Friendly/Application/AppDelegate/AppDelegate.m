//
//  AppDelegate.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AppDelegate.h"
#import "FRAppDependencies.h"

#import "FREventPreviewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

#import "UIImageView+Webcache.h"

#import "BFURL.h"

@interface AppDelegate ()
@property (nonatomic, strong) FRAppDependencies* appDependencies;
@property (strong, nonatomic) id<GAITracker> tracker;
@property (nonatomic, copy) FBSDKDeferredAppLinkHandler handler;

@end


static NSString *const kGaPropertyId = @"UA-78423743-1"; // Идентификатор приложения.
static BOOL const kGaDryRun = NO;
static int const kGaDispatchPeriod = 20;

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [FBSDKAppEvents activateApp];
    
    [self initializeGoogleAnalytics];
    [[GAI sharedInstance] setTrackUncaughtExceptions:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    self.appDependencies.window = self.window;
    [self.appDependencies handleApplicationStart:application options:launchOptions];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    NSDictionary *apnsBody = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (apnsBody) {
                [self.appDependencies handleApplication:application receiveNotification:apnsBody];
        
    }
    
    NSURL* url = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];
    if (url) {
        BSDispatchBlockAfter(2, ^{
            
            [self.appDependencies handleOpenUrl:url];
        });
    }
    
    if (launchOptions[UIApplicationLaunchOptionsURLKey] == nil) {
    
        @weakify(self);
                self.handler = ^(NSURL * url, NSError *error) {
                    @strongify(self);
                    if (url) {
                        [self parseUrl:url sourceAplication:@"com.facebook.Facebook"];
                    }
                };
        
//        [[FBSDKApplicationDelegate sharedInstance] setValue:self.handler forKey:@"_organicDeeplinkHandler"];
        
                [FBSDKAppLinkUtility fetchDeferredAppLink:self.handler];
    
        
    } else {
        
       NSURL* url = (NSURL *)[launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
        [self parseUrl:url sourceAplication:@"com.facebook.Facebook"];
    }
    
    
    return true;
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (notificationSettings.types != UIUserNotificationTypeNone) {
        [application registerForRemoteNotifications];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [self.appDependencies handleApplicationRegisterForNotificationsWithToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [self.appDependencies handleApplication:application didFailToRegisterForRemoteNotificationsWithError:error];
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    [self.appDependencies handleApplication:application receiveNotification:[notification userInfo]];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self.appDependencies handleApplication:application receiveNotification:userInfo];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;

    [self.appDependencies handleApplicationWillBecomeActive:application];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    if (APP_DELEGATE.state == RegistrationStateMiddleRegistration)
    {
        id<GAITracker> tracker = APP_DELEGATE.tracker;
        [tracker set:kGAIScreenName value:@"HomeScreen"];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                              action:@"Drop registration"
                                                               label:@"First registration"
                                                               value:nil] build]];
    }
}

- (BOOL)canOpenURL:(NSURL *)url
{
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(NSDictionary *)options {
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
                                                               annotation:options[UIApplicationOpenURLOptionsAnnotationKey]
                    ];
    
    
//    [self parseUrl:url sourceAplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    // Add any custom logic here.
    return handled;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if (!url) {
        return NO;
    }


    [self.appDependencies handleOpenUrl:url];
    
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation ];
    
    if (handled) {
        return handled;
    }
    
    // If the SDK did not handle the incoming URL, check it for app link data
    
    [self parseUrl:url sourceAplication:sourceApplication];
    return YES;
}

- (void)parseUrl:(NSURL*)url sourceAplication:(NSString*)sourceApplication {
    BFURL *parsedUrl = [BFURL URLWithInboundURL:url sourceApplication:sourceApplication];
    if ([parsedUrl appLinkData]) {
        NSURL *targetUrl = [parsedUrl targetURL];
        
        NSURLComponents *urlComponents = [NSURLComponents componentsWithURL:targetUrl resolvingAgainstBaseURL:NO];
        NSArray *queryItems = urlComponents.queryItems;
        NSString *refCode = [self valueForKey:@"referral" fromQueryItems:queryItems];
        NSString *eventId = [self valueForKey:@"event_id" fromQueryItems:queryItems];
        
        if (refCode == nil) {
            NSDictionary* ddd = [parsedUrl inputQueryParameters];
            refCode = ddd[@"referral"];
        }
        
        if (refCode){
            [[NSUserDefaults standardUserDefaults] setObject:refCode forKey:REFERENCE_INVITE];
            
            if (eventId) {
                [[NSUserDefaults standardUserDefaults] setObject:eventId forKey:EVENT_ID_INVITE];
            }
        }
        
    }

}

#pragma mark - Public

- (void)sendToGAScreen:(NSString *)screenName
{
    [self.tracker set:kGAIScreenName value:screenName];
    [self.tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

#pragma mark - Privates

- (NSString *)valueForKey:(NSString *)key
           fromQueryItems:(NSArray *)queryItems
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name=%@", key];
    NSURLQueryItem *queryItem = [[queryItems
                                  filteredArrayUsingPredicate:predicate]
                                 firstObject];
    return queryItem.value;
}

- (void)initializeGoogleAnalytics {
    self.state = RegistrationStateStart;
    
    [[GAI sharedInstance] setDispatchInterval:kGaDispatchPeriod];
    [[GAI sharedInstance] setDryRun:kGaDryRun];
    self.tracker = [[GAI sharedInstance] trackerWithTrackingId:kGaPropertyId];
}

- (void) application:(UIApplication *)application handleWatchKitExtensionRequest:(NSDictionary *)userInfo reply:(void (^)(NSDictionary *))reply
{
    [self.appDependencies handleApplication:application withWatchKitExtensionRequest:userInfo];
}

- (void) applicationDidBecomeActive:(UIApplication *)application {
    
    [self.appDependencies handleApplicationDidBecomeActive:application];
    [FBSDKAppEvents activateApp];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    
    SDImageCache *imageCache = [SDImageCache sharedImageCache];
    [imageCache clearMemory];
    [imageCache clearDisk];
}


#pragma mark - Lazy Load

- (FRAppDependencies *)appDependencies
{
    if (!_appDependencies)
    {
        _appDependencies = [FRAppDependencies new];
    }
    return _appDependencies;
}

- (UIWindow *)window
{
    if (!_window)
    {
        _window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    }
    return _window;
}

@end
