//
//  AdViewController.m
//  Friendly
//
//  Created by Dmitry on 08.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AdViewController.h"

#import "GTMOAuth2ViewControllerTouch.h"
#import "GTLCalendar.h"

@interface AdViewController ()

@property (nonatomic, strong) GTLServiceCalendar *service;

@end

@implementation AdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.service = [[GTLServiceCalendar alloc] init];
    self.service.authorizer =
    [GTMOAuth2ViewControllerTouch authForGoogleFromKeychainForName:kKeychainItemName
                                    clientID:@"565571189667-a6ape11q5j81ik4juu1rsfvrcq0b77r5.apps.googleusercontent.com"
                                clientSecret:nil];
    
    
//
//    NSLog(@"%@", self.service);
    
    
    
    //- See more at: http://yuluer.com/page/dfjbdcje-google-calendar-api-add-calendar-for-objective-c.shtml#sthash.Cr1kUZJG.dpuf

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (!self.service.authorizer.canAuthorize) {
        // Not yet authorized, request authorization by pushing the login UI onto the UI stack.
        [self presentViewController:[self createAuthController] animated:YES completion:nil];
        
    } else {
//        [self fetchEvents];
        
        
        GTLCalendarEvent *newEvent = [GTLCalendarEvent object];
        newEvent.summary =   @"kjlj";
        newEvent.descriptionProperty = @"kjhlk";
        
        
        NSDate *start = [NSDate date];//[FRDateManager dateFromServerWithString:event.event_start];
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

        
    }
}


- (void)viewController:(GTMOAuth2ViewControllerTouch *)viewController
      finishedWithAuth:(GTMOAuth2Authentication *)authResult
                 error:(NSError *)error {
    
    
    if (error != nil) {
        //[self showAlert:@"Authentication Error" message:error.localizedDescription];
        self.service.authorizer = nil;
    }
    else {
        self.service.authorizer = authResult;
        
        
        GTLCalendarEvent *newEvent = [GTLCalendarEvent object];
        newEvent.summary =   @"kjlj";
        newEvent.descriptionProperty = @"kjhlk";
        
        
        NSDate *start = [NSDate date];//[FRDateManager dateFromServerWithString:event.event_start];
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
        

        
        
//        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (GTMOAuth2ViewControllerTouch *)createAuthController {
    GTMOAuth2ViewControllerTouch *authController;
    // If modifying these scopes, delete your previously saved credentials by
    // resetting the iOS simulator or uninstall the app.
    NSArray *scopes = [NSArray arrayWithObjects:kGTLAuthScopeCalendar, nil];
    authController = [[GTMOAuth2ViewControllerTouch alloc]
                      initWithScope:[scopes componentsJoinedByString:@" "]
                      clientID:kGoogleAuth
                      clientSecret:nil
                      keychainItemName:kKeychainItemName
                      delegate:self
                      finishedSelector:@selector(viewController:finishedWithAuth:error:)];
    return authController;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
