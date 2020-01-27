//
//  FRMyEventsViewController.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsViewController.h"
#import "FRMyEventsSegmentedMenu.h"
#import "FRMyEventsCellViewModel.h"
#import "FREventTransport.h"
#import "FRRequestTransport.h"
#import "FRMyEventsHostCell.h"
#import "FRMyEventsCell.h"
#import "FRMyEventsToolbar.h"
#import "FRMyEventsCellToolbar.h"
#import "FRUserManager.h"
#import "FRCreateEventWireframe.h"
#import "FRMyProfileWireframe.h"
#import "FRMyEventsGuestViewController.h"
#import "FRMyEventsMoreViewController.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FREventRequestsViewController.h"
#import "FREventPreviewController.h"
#import "FRShareEventViewController.h"
#import "FRTransitionAnimator.h"
#import "FRCreateEventInviteToCoHostViewController.h"
#import "FRBadgeCountManager.h"
#import "FREmptyStateView.h"
#import "BSHudHelper.h"
#import "FRDateManager.h"
#import "FRSearchViewController.h"
#import "FRPrivateChatWireframe.h"

@interface FRMyEventsViewController () <UITableViewDataSource, UITableViewDelegate, FRMyEventsSegmentedMenuDelegate, FRMyEventsCellToolbarDelegate, FRMyEventsMoreViewControllerDelegate, FRMyEventsCellDelegate, FREventRequestsViewControllerDelegate, NSFetchedResultsControllerDelegate, FRMyEventsGuestViewControllerDelegate>

@property (strong, nonatomic) FRMyEventsSegmentedMenu *segmentedMenu;
@property (strong, nonatomic) UITableView* myEventsTableView;
@property (strong, nonatomic) FRMyEventsCellViewModel* myEventsCellModel;
@property (strong, nonatomic) FRMyEventsHostCell* hostCell;
@property (strong, nonatomic) NSArray* hostingModels;
@property (strong, nonatomic) NSArray* joiningModels;
@property (strong, nonatomic) NSArray* models;
@property (strong, nonatomic) FRMyEventsToolbar* toolbar;
@property (assign, nonatomic) FRMyEventsCellType typeCell;
@property (strong, nonatomic) NSString* eventId;
@property (assign, nonatomic) NSInteger badgeCount;
@property (strong, nonatomic) FREmptyStateView* emptyStateView;
@property (nonatomic, strong) NSFetchedResultsController* frc;


@end

@implementation FRMyEventsViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.emptyStateView.hidden = YES;
    [self checkEmptyState];
    [self updateData];
    [self.toolbar updateAvatarPhoto];
    [self.hostCell updateAvatarPhoto];
    self.badgeCount = [FRUserManager sharedInstance].eventRequestsCount;

    [self toolbar];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [APP_DELEGATE sendToGAScreen:@"MyEventsScreen"];
    
//    [self updateData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emptyStateView.hidden = YES;
//    [self checkEmptyState];
    [self segmentedMenu];
    self.segmentedMenu.delegate = self;
    [self.toolbar updateBadgeWithCount:[FRUserManager sharedInstance].eventRequestsCount];
    [self myEventsTableView];
    [self hostCell];
    [self.hostCell addTarget:self action:@selector(showCreateEvent:) forControlEvents:UIControlEventTouchUpInside];
    [self.view setBackgroundColor:[UIColor bs_colorWithHexString:@"#E8EBF1"]];
//    [self.myEventsTableView reloadData];
    [self updateFrcForHosting:true];
}


-(void)checkEmptyState
{
    if (self.typeCell == FRMyEventsCellTypeHosting)
    {
        [self.emptyStateView.titleLabel setText:@"Your not hosting anything"];
        [self.emptyStateView.subtitleLabel setText:@"I think it's time you create you first\nevent which will live here"];
        if (!self.myEventsTableView.visibleCells.count)
        {
//            self.emptyStateView.hidden = NO;
        }
        else
        {
        if (([FRUserManager sharedInstance].currentUser.hostingEvents.allObjects.count))
        {
//            self.emptyStateView.hidden = YES;
        }
        else
        {
//            self.emptyStateView.hidden = NO;
        }
        }
    }
    if (self.typeCell == FRMyEventsCellTypeJoining)
    {
        [self.emptyStateView.titleLabel setText:@"Not attending anything?"];
        [self.emptyStateView.subtitleLabel setText:@"Cant find an event you like? Host one\nand even ask a buddy to co-host"];
//        if (([FRUserManager sharedInstance].currentUser.joingEvents.allObjects.count))
//        {
//            self.emptyStateView.hidden = YES;
//        }
//        else
//        {
//            self.emptyStateView.hidden = NO;
//        }
    }
}


#pragma mark - Delegates

-(void)updateData
{
    [self getData];
//    [self checkEmptyState];
    [self.myEventsTableView reloadData];
//    [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
        [FRUserManager sharedInstance].eventRequestsCount = count;
        [self.toolbar updateBadgeWithCount:[FRUserManager sharedInstance].eventRequestsCount];
    }];
    [self.toolbar updateBadgeWithCount:self.badgeCount];
}

-(void)getData
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
//    self.emptyStateView.hidden = YES;
    [FREventTransport getHostingEventWithSuccess:^(NSArray<FREvent*>* events) {
        self.hostingModels = [FRUserManager sharedInstance].currentUser.hostingEvents.allObjects;
        
        [self checkEmptyState];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    } failure:^(NSError *error) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                  @"Error" message:error.localizedDescription  delegate:self
                                                 cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
        [alertView show];
    }];
    
    [FREventTransport getJoingEventWithSuccess:^(NSArray<FREvent*>* events) {
        
        self.joiningModels = [FRUserManager sharedInstance].currentUser.joingEvents.allObjects;
        
        [self checkEmptyState];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    }
                                       failure:^(NSError *error) {
                                           UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                                                     @"Error" message:error.localizedDescription  delegate:self
                                                                                    cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                                           [alertView show];
                                       }];
    [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
}

- (void)showSearch
{
//    [[FRMyProfileWireframe new] presentMyProfileControllerFromNavigationController:self.navigationController withBackButton:YES];
    FRSearchViewController* sVC = [FRSearchViewController new];
    [self.navigationController pushViewController:sVC animated:YES];
}

- (void)showEventRequests
{
    FREventRequestsViewController* requestVC = [FREventRequestsViewController new];
    requestVC.delegate = self;
//    UINavigationController* requestNV = [[UINavigationController alloc] initWithRootViewController:requestVC];
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.navigationController.view.layer addAnimation:transition forKey:nil];
//    [self.navigationController pushViewController:requestVC animated:NO];
    [self presentViewController:requestVC animated:YES completion:nil];
}

- (void)guestsSelectWithUser:(NSMutableArray*)users andEvent:(FREvent *)event
{
    FRMyEventsGuestViewController* guestsVC = [FRMyEventsGuestViewController new];
    guestsVC.heightFooter = 310;
    guestsVC.users = users;
    guestsVC.eventId = event.eventId;
    guestsVC.event = event;
    guestsVC.delegate = self;
    if (self.typeCell == FRMyEventsCellTypeHosting) {
        [guestsVC updateWithHostingType];
    }
    UINavigationController* unv = [[UINavigationController alloc] initWithRootViewController:guestsVC];
    unv.navigationBarHidden = YES;
    unv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    unv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:unv animated:YES completion:nil];
}

- (void) leaveEvent:(NSString *)eventId
{
    
    UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Warning", nil) message:FRLocalizedString(@"Are you sure you want to leave this event?", nil) preferredStyle:UIAlertControllerStyleAlert];
    
  
    UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"Yes", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
//        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull context) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
            FREvent* event = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId] inContext:context];
            
            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            [currentUser removeJoingEventsObject:event];
            [event MR_deleteEntityInContext:context];
//        }];
        
        [FRRequestTransport unsubscribeWithEventId:eventId success:^{
            
        } failure:^(NSError *error) {}];
    }];
    
    UIAlertAction* decline = [UIAlertAction actionWithTitle:FRLocalizedString(@"No", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}];
    [alertController addAction:decline];
    [alertController addAction:accept];
    [self.navigationController presentViewController:alertController animated:true completion:nil];
    self.eventId = eventId;
}

- (void)showChatForEvent:(FREvent *)event {
    [[FRPrivateChatWireframe new] presentPrivateChatControllerFromNavigation:self.navigationController forEvent:event];
}

//- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
//{
//    if (buttonIndex == 1) {
//        [FRRequestTransport unsubscribeWithEventId:self.eventId success:^{
//            [self updateData];
//        } failure:^(NSError *error) {
//            //
//        }];
//    }
//}

-(void)presentShareEventControllerWithModel:(FREvent*)model
{
    FRShareEventViewController* shareVC = [FRShareEventViewController new];
    
    [shareVC updateWithEvent:model];
    [self presentViewController:shareVC animated:YES completion:nil];
}

-(void)showCreateEvent:(UIButton*)sender
{
    [[FRCreateEventWireframe new] presentCreateEventControllerFromNavigationController:self event:nil animation:YES];
}

- (void) moreSelectWithEvent:(NSString*)eventId andModel:(FREvent*)model
{
    FRMyEventsMoreViewController* moreVC = [FRMyEventsMoreViewController new];
    [moreVC updateWithEventId:eventId andModel:model];
    moreVC.delegate = self;
    moreVC.heightFooter = 240;
    [self presentViewController:moreVC animated:YES completion:nil];
}

- (void) showInviteWithEvent:(NSString*)eventId andEvent:(FREvent *)event
{
    FRCreateEventInviteFriendsViewController* inviteVC = [FRCreateEventInviteFriendsViewController new];
    inviteVC.heightFooter = 240;
    [inviteVC updateWithEventId:eventId andEvent:event];
    inviteVC.isVCForCreating = NO;
    [self presentViewController:inviteVC animated:YES completion:nil];
}

- (void) editEvent:(FREventModel *)event
{
    [[FRCreateEventWireframe new] presentCreateEventControllerFromNavigationController:self.navigationController event:event animation:YES];
}

- (void) shareEvent:(FREventModel *)event
{
    [self presentShareEventControllerWithModel:event];
}


#pragma mark - MenuDelegate

- (void) selectedHosting
{
    self.typeCell = FRMyEventsCellTypeHosting;
    [self updateFrcForHosting:true];
    self.hostCell.hidden = NO;
    [_hostCell mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.segmentedMenu.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        make.height.equalTo(@55);
    }];
    [self checkEmptyState];
    [_myEventsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.segmentedMenu.mas_bottom).offset(70);
    }];
    
}

- (void) selectedJoining
{
    self.typeCell = FRMyEventsCellTypeJoining;
    [self updateFrcForHosting:false];
    self.hostCell.hidden = YES;
    [self checkEmptyState];
    [_myEventsTableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.top.equalTo(self.segmentedMenu.mas_bottom).offset(10);
    }];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 208;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.frc.fetchedObjects.count == 0) {
        self.emptyStateView.hidden = false;
    } else {
        self.emptyStateView.hidden = true;
    }
    
    return self.frc.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    static NSString *CellIdentifier;
    CellIdentifier = @"EventView";
    FRMyEventsCell *eventViewCell = (FRMyEventsCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!eventViewCell)
    {
        eventViewCell = [[FRMyEventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    FRMyEventsCellViewModel* cellViewModel = [FRMyEventsCellViewModel initWithModel:[self.frc objectAtIndexPath:indexPath] type:self.typeCell];
    eventViewCell.footerView.cellToolBarDelegate = self;
    eventViewCell.delegate = self;
    [eventViewCell updateWithModel:cellViewModel];
    NSString* dayOfWeek = [[FRDateManager dayOfWeek:cellViewModel.eventModel.event_start] uppercaseString];
    NSString* day =  [[FRDateManager dayOfMonth:cellViewModel.eventModel.event_start] uppercaseString];
    [eventViewCell.dateView updateWithDay:day andDayOfWeek:dayOfWeek];
    returnCell = eventViewCell;
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

-(void)showEventBySelectingRowWithModel:(FREvent*)model fromCell:(FRMyEventsCell*)cell
{
    CGRect cellRect = [self.myEventsTableView rectForRowAtIndexPath:[self.myEventsTableView indexPathForCell:cell]];
    
    cellRect = CGRectOffset(cellRect, -self.myEventsTableView.contentOffset.x, -self.myEventsTableView.contentOffset.y);
    
    cellRect.size = cell.headerView.frame.size;
    cellRect.origin.y += self.myEventsTableView.frame.origin.y + 5;
    
    self.willShowEventPreview = true;
    
    [self setNeedsStatusBarAppearanceUpdate];
    
    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:model fromFrame:cellRect];
    
    @weakify(self);
    vc.complite = ^{
        @strongify(self);
        self.willShowEventPreview = false;
    };
    
    if (self.typeCell == FRMyEventsCellTypeHosting)
    {
        vc.isHostingEvent = YES;
    }
    if (self.typeCell == FRMyEventsCellTypeJoining)
    {
        vc.isAttendingStatus = YES;
    }
    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:vc];
    nv.navigationBarHidden = YES;
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[FRTransitionAnimator new] presentViewController:nv from:self];
    
//    [self presentViewController:vc animated:YES completion:nil];
}


#pragma mark - LazyLoad

- (FREmptyStateView*) emptyStateView
{
    if (!_emptyStateView)
    {
        _emptyStateView = [FREmptyStateView new];
        [self.view addSubview:_emptyStateView];
        [self.view insertSubview:_emptyStateView aboveSubview:self.myEventsTableView];
        [_emptyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    return _emptyStateView;
}

- (FRMyEventsToolbar*) toolbar
{
    if (!_toolbar)
    {
        _toolbar = [FRMyEventsToolbar new];
        _toolbar.delegate = self;
        _toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        [self.view addSubview:_toolbar];
        [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@65);
        }];
    }
    return _toolbar;
}

- (FRMyEventsHostCell*) hostCell
{
    if (!_hostCell)
    {
        _hostCell = [FRMyEventsHostCell new];
        [self.view addSubview:_hostCell];
        [_hostCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentedMenu.mas_bottom).offset(10);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@55);
        }];
    }
    return _hostCell;
}

- (FRMyEventsSegmentedMenu*) segmentedMenu
{
    if (!_segmentedMenu)
    {
        _segmentedMenu = [FRMyEventsSegmentedMenu new];
        [self.view addSubview:_segmentedMenu];
        [_segmentedMenu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@40);
        }];
    }
    return _segmentedMenu;
}

-(UITableView*) myEventsTableView
{
    if (!_myEventsTableView)
    {
        _myEventsTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _myEventsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _myEventsTableView.allowsSelection = YES;
        [_myEventsTableView setBackgroundColor:[UIColor bs_colorWithHexString:@"#E8EBF1"]];
        _myEventsTableView.bounces = NO;
        _myEventsTableView.delegate = self;
        _myEventsTableView.clipsToBounds = YES;
        _myEventsTableView.dataSource = self;
        [self.view addSubview:_myEventsTableView];
        [_myEventsTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.view);
            make.top.equalTo(self.hostCell.mas_bottom).offset(10);
        }];
    }
    return _myEventsTableView;
}

- (NSFetchedResultsController*)frc {
    
    if (!_frc) {
        
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"%@ contains self AND isDelete == %@",[FRUserManager sharedInstance].currentUser.hostingEvents, @(false)];
        
        _frc = [FREvent MR_fetchAllSortedBy:@"createdAt" ascending:false withPredicate:predicate groupBy:nil delegate:self];
    }
    
    return _frc;
}

- (void)updateFrcForHosting:(BOOL)isHosting {
    
     NSPredicate* predicate;
    
    if (isHosting) {
        predicate = [NSPredicate predicateWithFormat:@"creator_id == %@ AND isDelete == %@ OR partnerHosting == %@ AND partnerIsAccepted == %@",[[FRUserManager sharedInstance].currentUser user_id], @(false), [[FRUserManager sharedInstance].currentUser user_id], @(true)];
    } else {
        predicate = [NSPredicate predicateWithFormat:@"%@ contains self AND isDelete == %@",[[FRUserManager sharedInstance].currentUser joingEvents], @(false)];
    }
    
    [self.frc.fetchRequest setPredicate: predicate];
    
    NSError* error;
    if(![self.frc performFetch:&error]) {
        NSLog(@"%@", error);
    }
    [self.myEventsTableView reloadData];
}
#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.myEventsTableView reloadData];
    [self checkEmptyState];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.willShowEventPreview) {
        setStatusBarColor([FRUserManager sharedInstance].statusBarStyle == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor]);
        return [FRUserManager sharedInstance].statusBarStyle;
    }
    
    setStatusBarColor([UIColor blackColor]);
    return  UIStatusBarStyleDefault;
}


@end
