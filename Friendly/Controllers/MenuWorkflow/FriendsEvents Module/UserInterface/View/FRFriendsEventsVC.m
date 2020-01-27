//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsVC.h"
#import "FRFriendsEventsController.h"
#import "FRFriendsEventsDataSource.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "FRFriendsEventsNavBar.h"
#import "FRMessagerFriendsHeader.h"
#import "FREventsCell.h"


@interface FRFriendsEventsVC ()<NSFetchedResultsControllerDelegate, FRFriendsEventsControllerDelegate, FREventsCellViewModelDelegate, FRMessagerFriendsHeaderDelegate>

@property (nonatomic, strong) FRFriendsEventsController* controller;
@property (nonatomic, strong) UIRefreshControl* topRefresh;
@property (nonatomic, strong) FRFriendsEventsNavBar* navBar;

@property (nonatomic, strong) FRMessagerFriendsHeader* tableHeaderView;
@property (nonatomic, strong) UIView* emptyView;
@property (nonatomic, strong) UIRefreshControl* refreshControl;
@property (nonatomic, strong) NSFetchedResultsController* friendsFRC;
@end


@implementation FRFriendsEventsVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRFriendsEventsController alloc] initWithTableView:self.tableView];
        self.controller.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
    
    [super viewWillAppear:animated];
//    [self updateBanner];
    [self updateFriendsToMeetSection];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self action:@selector(bottomRefresh:) forControlEvents:UIControlEventValueChanged];
//    self.tableView.bottomRefreshControl = self.refreshControl;
    
    self.topRefresh = [UIRefreshControl new];
    [self.topRefresh addTarget:self action:@selector(topRefresh:) forControlEvents:UIControlEventValueChanged];
    
    [self.tableView addSubview:self.topRefresh];
    
    self.navBar.titleLabel.text = @"Friends events";

    @weakify(self);

    [[self.navBar.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    self.tableHeaderView = [FRMessagerFriendsHeader new];
    self.tableHeaderView.titleLabel.text = @"FRIENDS AVAILABLE FOR A MEET";
    self.tableHeaderView.delegate = self;
    self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 160);
    self.tableView.backgroundColor = [UIColor bs_colorWithHexString:@"#E8EBF1"];
    
    self.emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        self.tableView.tableHeaderView = self.emptyView;
    [self updateFriendsToMeetSection];
    
    self.friendsFRC = [UserEntity MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"currentUser != NIL AND availableStatus == %@", @0] sortedBy:@"firstName" ascending:true];
    self.friendsFRC.delegate = self;
    [self.friendsFRC performFetch:nil];
    [self upHeader:self.friendsFRC.fetchedObjects];
}


- (void)updateFriendsToMeetSection {

//    [self.tableHeaderView updateWithFriends:users];
    
    }

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSArray* friends = controller.fetchedObjects;
    
    [self upHeader:friends];
    [self.tableHeaderView.collectionView reloadData];

}

- (void)upHeader:(NSArray*)friends {
    
    if (friends.count && [self.tableView.tableHeaderView isEqual:self.emptyView]) {
        self.tableView.tableHeaderView = self.tableHeaderView;
        [self.tableHeaderView.collectionView reloadData];
        [self.tableView reloadData];
    }
    
    if (!friends.count) {
        self.tableView.tableHeaderView = self.emptyView;
        [self.tableView reloadData];
    }
}

- (void)topRefresh:(UIRefreshControl*)sender {
    [self.eventHandler updateNewEvent];
}

- (void)bottomRefresh:(UIRefreshControl*)sender {
  NSInteger eventCount = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0];
    
    [self.eventHandler updateOldEventWithCount:eventCount];
}


- (void)changePositionY:(CGFloat)y
{
    
//    [self.navBar setColorAlpha:y / 40];
}

- (void)updateDataSource:(FRFriendsEventsDataSource*)dataSource
{
    
}

#pragma mark - FRMessagerFriendsHeaderDelegate

- (void)selectedUser:(UserEntity*)user {
    [self.eventHandler selectedFriend:user];
}

- (id)objectForIndexPath:(NSIndexPath*)indexPath {
    return  [self.friendsFRC objectAtIndexPath:indexPath];
}

- (NSInteger)countObject {
    return self.friendsFRC.fetchedObjects.count;
}

- (void)updateAvailableFriends {
    [self.eventHandler updateAvailableFriends:self.friendsFRC.fetchedObjects.count];
}

#pragma mark - FRFriendsEventsControllerDelegate

- (void)selectedFriendsInvite
{
    
}


#pragma mark - User Interface

- (void)updatedEvents
{
    [self.tableView.bottomRefreshControl endRefreshing];
    [self.topRefresh endRefreshing];
    [self.tableView reloadData];
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.001)];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.001)];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
    }
    return _tableView;
}

- (FRFriendsEventsNavBar*)navBar
{
    if (!_navBar)
    {
        _navBar = [FRFriendsEventsNavBar new];
        [self.view addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}
#pragma mark - FRTableController Delegate

#pragma mark - FREventsCellViewModelDelegate

- (void)userPhotoSelected:(NSString*)userId
{
    [self.eventHandler userPhotoSelected:userId];
}

- (void)partnerPhotoSelected:(NSString*)partnerId
{
    [self.eventHandler userPhotoSelected:partnerId];
}

- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event
{
    [self.eventHandler joinSelectedWithEventId:eventId andModel:event];
}

- (void)selectedShareEvent:(FREvent*)event
{
    [self.eventHandler selectedShareEvent:event];
}

- (void)selectedEvent:(FREventsCellViewModel*)viewModel
{
        CGRect cellRect = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:viewModel.cell]];
        
        cellRect = CGRectOffset(cellRect, -self.tableView.contentOffset.x, -self.tableView.contentOffset.y);
        
        FREventsCell* cell = (FREventsCell*)viewModel.cell;
        
        cellRect.size = cell.eventImage.frame.size;
        cellRect.origin.y += self.tableView.frame.origin.y + 10;
    
    [self.eventHandler selectedEvent:[viewModel domainModel] fromFrame:cellRect];
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


- (void)updateOldEvent {

    NSInteger eventCount = [self.tableView.dataSource tableView:self.tableView numberOfRowsInSection:0];
    
    [self.eventHandler updateOldEventWithCount:eventCount];


}
- (void)showAddUsers {
    [self.eventHandler showAddUsers];
}
@end




