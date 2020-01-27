//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenVC.h"
#import "FRHomeScreenController.h"
#import "FRHomeScreenDataSource.h"
#import "FRStyleKit.h"
#import "FRUserManager.h"

#import "FRCreateEventWireframe.h"
#import "FRMyEventsViewController.h"
#import "FRCreateEventCategoryViewController.h"
#import "FREventRequestsViewController.h"
#import "FRCreateEventLocationSelectViewController.h"

#import "FRCreateEventInviteFriendsViewController.h"
#import "FRSearchViewController.h"

#import "FRJoinEventViewController.h"
#import "FREventsWireframe.h"
#import "FREventsVC.h"
#import "FRMessagerWireframe.h"

#import "FRCalendarManager.h"
#import "UITabBarItem+CustomBadge.h"
#import "FRHomeWireframe.h"
#import "FRMyProfileWireframe.h"
#import "UIImage+helper.h"
#import "FRHomeVC.h"
#import "FRSettingsTransport.h"
#import "UIImageHelper.h"



@interface FRHomeScreenVC () <UITabBarControllerDelegate>

@property (nonatomic, strong) FRHomeScreenController* controller;
@property (nonatomic, strong) UITableView* tableView;

//@property (nonatomic, strong) UIButton* messageBadge;

@end


@implementation FRHomeScreenVC


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    static BOOL verify = true;
    
    if (verify) {
        
        [FRCalendarManager updateCalendarFromVC:self];
        verify = false;
    } else {
        verify = true;
    }
    [self.selectedViewController viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (APP_DELEGATE.state == RegistrationStateMiddleRegistration) {
        APP_DELEGATE.state = RegistrationStateFoolRegistration;
        
        id<GAITracker> tracker = APP_DELEGATE.tracker;
        [tracker set:kGAIScreenName value:@"HomeScreen"];
        [tracker send:[[GAIDictionaryBuilder createEventWithCategory:@"Action"
                                                              action:@"Registration"
                                                               label:@"First registration"
                                                               value:nil] build]];
    }
    if ([self.selectedViewController isKindOfClass: [FRHomeVC class]]) {
        
    }
    [self.selectedViewController viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.selectedViewController viewDidDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    [FRSettingsTransport getAdStatusWithSuccess:^(BOOL canShow) {
        [FRUserManager sharedInstance].canShowAdvertisement = canShow;
    } failure:^(NSError *error) {
        
    }];
    
    
    [[FRWebSoketManager shared] connect];
    self.tabBar.tintColor = [UIColor bs_colorWithHexString:kPurpleColor];
    
    UINavigationController* eventsNav = [[UINavigationController alloc]init];
    eventsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[FRStyleKit imageOfTabHomeCanvas] tag:0];
    eventsNav.navigationBarHidden = YES;

    
    FRHomeWireframe* wirefriem = [FRHomeWireframe new];
    [wirefriem presentHomeControllerFromNavigationController:eventsNav];

    UIViewController* vc2 = [UIViewController new];
    vc2.view.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
    vc2.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[FRStyleKit imageOfCombinedShapeCanvas6] tag:2];
    
    
    UINavigationController* messagesNC = [UINavigationController new];
    messagesNC.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[FRStyleKit imageOfTabMessagesCanvas] tag:3];
    messagesNC.navigationBarHidden = YES;
    
    [[FRMessagerWireframe new] presentMessagerControllerFromNavigationController:messagesNC];

    FRMyEventsViewController* vc4 = [FRMyEventsViewController new];
    
    UINavigationController* myEventsNav = [[UINavigationController alloc]initWithRootViewController:vc4];
   
    myEventsNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[FRStyleKit imageOfFill1Canvas3] tag:1];
    myEventsNav.navigationBarHidden = YES;
    
    
    UINavigationController* profileNav = [[UINavigationController alloc]init];
    profileNav.navigationBarHidden = YES;
    profileNav.tabBarItem = [[UITabBarItem alloc] initWithTitle:nil image:[FRStyleKit imageOfCombinedShapeCanvas8] tag:4];
   
    [[FRMyProfileWireframe new] presentMyProfileControllerFromNavigationController:profileNav withBackButton:NO];
    

    
    [self setViewControllers: @[
                        eventsNav,myEventsNav,vc2,messagesNC,profileNav
                        
                        ] animated:YES];
    
   self.tabBar.translucent = NO;
    
    self.delegate = self;
    
    [self.viewControllers enumerateObjectsUsingBlock:^(UIViewController *vc, NSUInteger idx, BOOL *stop) {
        vc.title = nil;
        vc.tabBarItem.imageInsets = UIEdgeInsetsMake(5, 0, -5, 0);
    }];
    

    
    [[UITabBar appearance] setBackgroundImage:[UIImage new]];
    [[UITabBar appearance] setShadowImage:[UIImageHelper imageFromColor:[UIColor bs_colorWithHexString:@"E4E6EA"]]];
    
    
       

    
    RACSignal* observ = RACObserve([FRUserManager sharedInstance], newMessageCount);
    [[observ deliverOnMainThread] subscribeNext:^(NSNumber* x) {

//        if (x.integerValue) {
//            
//            [messagesNC.tabBarItem setBadgeValue:x.stringValue];
//        } else {
//            [messagesNC.tabBarItem setBadgeValue:nil];
//        }
        [messagesNC.tabBarItem setCustomBadgeValue:x.stringValue withFont:FONT_MAIN_FONT(10) andFontColor:[UIColor blueColor] andBackgroundColor:[UIColor grayColor]];
        
    }];
    
    [[FRUserManager sharedInstance] setNewMessageCount:0];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys: [UIColor whiteColor], NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    
    
    UIColor * unselectedColor = [UIColor bs_colorWithHexString:@"ADB6CE"];
    // set color of unselected text
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:unselectedColor, NSForegroundColorAttributeName, nil]
                                             forState:UIControlStateNormal];
    
    // generate a tinted unselected image based on image passed via the storyboard
    for(UITabBarItem *item in self.tabBar.items) {
        // use the UIImage category code for the imageWithColor: method
        item.image = [[item.selectedImage imageWithColor:unselectedColor] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    
    BSDispatchBlockAfter(0,^{
       
         [FRDataBaseManager updateNewMessageCount];
    });
    
    

}




-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [viewController viewWillAppear:YES];
    
}

//This is the method that will draw the underline

-(UIImage *) ChangeViewToImage : (UIView *) viewForImage{
    
    UIGraphicsBeginImageContext(viewForImage.bounds.size);
    [viewForImage.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (void)hideTabBar:(UITabBarController *) tabbarcontroller
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    
    for(UIView *view in tabbarcontroller.view.subviews)
    {
        if([view isKindOfClass:[UITabBar class]])
        {
            [view setFrame:CGRectMake(view.frame.origin.x, height, view.frame.size.width, view.frame.size.height)];
        }
        else
        {
            [view setFrame:CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, height)];
        }
    }
    
    [UIView commitAnimations];
}


- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.tabBar.selectedItem.tag == 2)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:kCreateEventHelperFirstTime];
        [[FRCreateEventWireframe new] presentCreateEventControllerFromNavigationController:self event:nil animation:YES];
        return NO;
    }

    return YES;
}

 

#pragma mark - User Interface

- (void)updateDataSource:(FRHomeScreenDataSource *)dataSource
{
//    [self.controller updateDataSource:dataSource];
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

#pragma mark - FRTableController Delegate

- (void)dealloc {
    NSLog(@"Dealloc homescrn");
}

@end
