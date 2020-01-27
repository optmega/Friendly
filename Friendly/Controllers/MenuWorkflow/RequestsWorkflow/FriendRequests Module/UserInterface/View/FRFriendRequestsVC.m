//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsVC.h"
#import "FRFriendRequestsController.h"
#import "FRFriendRequestsDataSource.h"
#import "FRFriendRequestsView.h"
#import "FRRequestNavView.h"
#import "FRFriendRequestHeaderViewModel.h"
#import "FRFriendRequestsCell.h"
#import "FRSettingsTransport.h"
#import "FRFriendsListModel.h"
#import "FRUserManager.h"

@interface FRFriendRequestsVC ()

@property (nonatomic, strong) FRFriendRequestsController* controller;
@property (nonatomic, strong) FRFriendRequestsView* contentView;


@end


@implementation FRFriendRequestsVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentView = [FRFriendRequestsView new];
        self.controller = [[FRFriendRequestsController alloc]initWithTableView:self.contentView.tableView];
//        self.controller.scrollDelegate = self;
    }
    return self;
}

- (void)loadView
{
    self.view = self.contentView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [FRUserManager sharedInstance].friendsRequestCount = 0;
    [[FRUserManager sharedInstance] udpateFriendsRequest];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"FriendsRequestsScreen"];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.eventHandler viewWillApear];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FRFriendRequestHeaderViewModel* friendModel = [FRFriendRequestHeaderViewModel new];
    friendModel.title = @"FRIEND REQUESTS";
    
    FRFriendRequestHeaderViewModel* familiarModel = [FRFriendRequestHeaderViewModel new];
    familiarModel.title = @"PEOPLE YOU MAY KNOW";
    
    [self.controller.headerModelArray addObjectsFromArray:@[friendModel, familiarModel]];

    
    
    @weakify(self);
    [[self.contentView.navBar.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    [[self.contentView.navBar.rieghtButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler showAddFriends];
    }];
}


#pragma mark - User Interface

- (void)updateViewWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends
{
    self.controller.friendsCellModelArray  = [NSMutableArray arrayWithArray:friendRequests];
    self.controller.familiarCellModelArray = [NSMutableArray arrayWithArray:potentialFriends];
    
    [self.controller.tableView reloadData];
}

- (void)removePotentialFriend:(FRFriendFamiliarCellViewModel*)model
{
    if([self.controller.familiarCellModelArray containsObject:model])
    {
//        NSInteger row = [self.controller.familiarCellModelArray indexOfObject:model];
//        [self.controller.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:1]]
//                                         withRowAnimation:UITableViewRowAnimationTop];
        [self.controller.familiarCellModelArray removeObject:model];
        [self.controller.tableView reloadData];
    }
}

- (void)removeFriendRequest:(FRFriendRequestsCellViewModel*)model
{
    if ([self.controller.friendsCellModelArray containsObject:model])
    {
//        NSInteger row = [self.controller.friendsCellModelArray indexOfObject:model];
//        [self.controller.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:row inSection:0]]
//                                         withRowAnimation:UITableViewRowAnimationTop];
        [self.controller.friendsCellModelArray removeObject:model];
        [self.controller.tableView reloadData];
    }
}

- (void)updateDataSource:(FRFriendRequestsDataSource *)dataSource
{
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor(self.statusBarColor == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor]);
    return self.statusBarColor;
}

#pragma mark - FRTableController Delegate


@end
