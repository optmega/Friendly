//
//  FRCalendarManager.m
//  Friendly
//
//  Created by Dmitry on 14.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCalendarManager.h"
#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"
#import "FREventModel.h"
#import "FRDateManager.h"
#import "FREventTransport.h"
#import "FREventModel.h"

@interface FRCalendarManager ()

@property (nonatomic, strong) GTLServiceCalendar* service;
@property (nonatomic, copy) void(^complition)();
@property (nonatomic, strong) FREvent* event;
@property (nonatomic, weak) UIViewController* navContr;

@end

@implementation FRCalendarManager

+ (void)updateCalendarFromVC:(UIViewController*)vc
{
    FRCalendarManager* calendarManager = [FRCalendarManager sharedInstance];
    if (calendarManager.service.authorizer.canAuthorize) {
        
        [FREventTransport getApproveEventForCalendar:^(NSArray *events) {
            
            [events enumerateObjectsUsingBlock:^(FREvent*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:obj.objectID];
                [calendarManager addEvent:event fromController:nil complitionBlock:^{
                    [FREventTransport postEventToCalendar:event.eventId success:^{
                   } failure:^(NSError *error) {
                       NSLog(@"%@",error.localizedDescription);
                   }];
                    
                }];
            }];
            
        } failure:^(NSError *error) {
            NSLog(@"%@", error.localizedDescription);
        }];
    } else {
        
        if (vc) {
            
            if (![[[NSUserDefaults standardUserDefaults] objectForKey:CAN_UPDATE_CALENDAR] isEqual:@"No"])
            {
                return;
            }
            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:@"Hi! You have event😁" message:@"Do you want it add to calendar?" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* actionCanecel = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:CAN_UPDATE_CALENDAR];
            }];
            
            UIAlertAction* actionAccept = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [vc presentViewController:[calendarManager createAuthController] animated:YES completion:nil];
            }];
            
            [alertController addAction:actionCanecel];
            [alertController addAction:actionAccept];
            
            [vc presentViewController:alertController animated:YES completion:nil];
            
        }
    }
}


+ (instancetype)sharedInstance
{
    static FRCalendarManager* manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [FRCalendarManager new];
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.service = [[GTLServiceCalendar alloc] init];
        self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kGoogleAuth
                                                          clientSecret:nil];
    }
    return self;
}

- (void)addEvent:(FREvent*)event fromController:(UIViewController*)vc complitionBlock:(complition)complit
{
    
    if (!self.service.authorizer)
    {
        self.service.authorizer =
        [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                                              clientID:kGoogleAuth
                                                          clientSecret:nil];
        
        
    }
    
    self.complition = complit;
    self.event = event;
    
    if (!self.service.authorizer.canAuthorize) {
        
        [vc presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
        [self createCalendarEvent:event];
    }
}

- (void)createCalendarEvent:(FREvent*)event {
    
    GTLCalendarEvent *newEvent = [GTLCalendarEvent object];
    newEvent.summary = event.title;
    newEvent.descriptionProperty = [NSString stringWithFormat:@"Description: %@\nCategory: %@", event.info, event.category];
    newEvent.location = event.address;
    
  
    NSDate *start = event.event_start;
    NSDate* end = [start dateByAddingTimeInterval:60 * 60 * 24];
    
    GTLDateTime *startDateTime = [GTLDateTime dateTimeWithDate:start
                                                      timeZone:[NSTimeZone systemTimeZone]];
    GTLDateTime *endDateTime = [GTLDateTime dateTimeWithDate:end
                                                    timeZone:[NSTimeZone systemTimeZone]];
    
    newEvent.start = [GTLCalendarEventDateTime object];
    newEvent.start.dateTime = startDateTime;
    
    newEvent.end = [GTLCalendarEventDateTime object];
    newEvent.end.dateTime = endDateTime;
    
    GTLCalendarEventReminder *reminder = [GTLCalendarEventReminder object];
    reminder.minutes = [NSNumber numberWithInteger:10];
    reminder.method = @"email";
    
    newEvent.reminders = [GTLCalendarEventReminders object];
    newEvent.reminders.overrides = [NSArray arrayWithObject:reminder];
    newEvent.reminders.useDefault = [NSNumber numberWithBool:NO];
    
    GTLQueryCalendar* querty = [GTLQueryCalendar queryForEventsInsertWithObject:newEvent calendarId:@"primary"];
    [self.service executeQuery:querty delegate:self didFinishSelector:nil];

    if (self.complition)
    {
        self.complition();
    }
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    
    [viewController dismissViewControllerAnimated:true completion:nil];
    if (error != nil) {
      
        self.service.authorizer = nil;
        if (self.complition)
        {
            self.complition();
        }
    }
    else {
        self.service.authorizer = authResult;
        [self createCalendarEvent:self.event];
    }
}

- (UINavigationController *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendar, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kGoogleAuth
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:authController];
    navigationController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil)
                                                                         style:UIBarButtonItemStylePlain
                                                                        target:self
                                                                        action:@selector(didCanceledAuthorization)];
        
        authController.navigationItem.leftBarButtonItem = cancelButton;
        authController.navigationItem.title = @"Google Calendar";
        authController.navigationItem.rightBarButtonItems  = nil;
        authController.navigationItem.rightBarButtonItem = nil;
    });
    
    self.navContr = navigationController;
    return navigationController;
}

- (void)didCanceledAuthorization {
    [self.navContr dismissViewControllerAnimated:true completion:nil];
}

@end
