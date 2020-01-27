//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerVC.h"
#import "FRMessagerController.h"
#import "FRMessagerDataSource.h"
#import "FRMessagerContentView.h"
#import "FRMessagerFriendsHeader.h"
#import "FRBaseRoom.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "FRChatTransport.h"
#import "FRFriendsTransport.h"

@interface FRMessagerVC () <FRMessagerFriendsHeaderDelegate, UISearchBarDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) FRMessagerController* controller;
@property (nonatomic, strong) FRMessagerContentView* contentView;
@property (nonatomic, strong) FRMessagerFriendsHeader* tableHeaderView;
@property (nonatomic, strong) UIView* emptyView;
@property (nonatomic, strong) NSFetchedResultsController* friendsFRC;

@end


@implementation FRMessagerVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [FRMessagerController new];
        self.contentView = [FRMessagerContentView new];
    }
    return self;
}

- (void)loadView
{
    self.view = self.contentView;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.contentView.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentView.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.contentView.tableView.bounds.size.width, 0.1)];
    
    [[UITextField appearance] setTintColor:[UIColor bs_colorWithHexString:@"929AAF"]];
    self.emptyView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
    self.tableHeaderView = [FRMessagerFriendsHeader new];
    self.tableHeaderView.delegate = self;
    self.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 140);
    
    
    self.contentView.tableView.tableHeaderView = self.emptyView; //self.tableHeaderView;
    [self.controller updateWithTableView:self.contentView.tableView];
    
    self.contentView.searchBar.delegate = self;
    @weakify(self);
    [[self.contentView.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler showFriendRequest];
    }];
    
    [[self.contentView.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler showSearch];
    }];
    
    RACSignal* observ =  RACObserve([FRUserManager sharedInstance], friendsRequestCount);
    [observ subscribeNext:^(NSNumber* count) {
        [self.contentView updateFriendsCount:count];
    }];
    
    UIRefreshControl* bottomRefresh = [[UIRefreshControl alloc] init];
    [bottomRefresh addTarget:self action:@selector(bottomRefreshAction:) forControlEvents:UIControlEventValueChanged];
    self.contentView.tableView.bottomRefreshControl = bottomRefresh;
    bottomRefresh.alpha = 0;
    
    

    
//    self.friendsFRC = [UserEntity MR_fetchAllGroupedBy:nil withPredicate:[NSPredicate predicateWithFormat:@"currentUser != NIL"] sortedBy:@"firstName" ascending:true inContext:[NSManagedObjectContext MR_defaultContext]];
    
    self.friendsFRC.delegate = self;
    [self.friendsFRC performFetch:nil];
    [self upHeader:self.friendsFRC.fetchedObjects];
}


- (NSFetchedResultsController*) friendsFRC {

    if (!_friendsFRC) {
        NSFetchRequest* fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"UserEntity"];
        fetchRequest.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"lastName" ascending:true], [NSSortDescriptor sortDescriptorWithKey:@"user_id" ascending:true]];
        fetchRequest.predicate = [NSPredicate predicateWithFormat:@"currentUser != NIL"];
        
        
        _friendsFRC = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
    }
    
    return _friendsFRC;
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    NSArray* friends = controller.fetchedObjects;
    
    [self upHeader:friends];
    [self.tableHeaderView.collectionView reloadData];
    
}

- (void)upHeader:(NSArray*)friends {
    
    [self.tableHeaderView.collectionView reloadData];
}

- (void)bottomRefreshAction:(UIRefreshControl*)refreshControl {
    [self.eventHandler updateChatRoomsWithCount:[self.controller currentRoomsCount]];
}

- (void)updateTableHeader {
    
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true];
    NSArray* users = [[FRUserManager sharedInstance].currentUser.friends.allObjects sortedArrayUsingDescriptors:@[sort]];

    
    [self.tableHeaderView updateWithFriends:users];
    
    if (!self.tableHeaderView.superview) {
        
        [self.contentView.headerView addSubview: self.tableHeaderView];
    }
//    if (users.count) {
//        self.contentView.tableView.tableHeaderView = self.tableHeaderView;
//    } else {
//        self.contentView.tableView.tableHeaderView = self.emptyView;
//    }
}

- (void)updateChats {
    BSDispatchBlockToMainQueue(^{
        
        [self.contentView.tableView.bottomRefreshControl endRefreshing];
    });
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[FRUserManager sharedInstance] udpateFriendsRequest];
    [self updateTableHeader];
    
    [FRFriendsTransport getMyFriendsListWithSuccess:nil failure:nil];

    
    [FRChatTransport getAllRooms:^(FRChatRooms *rooms) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [FRDataBaseManager updateNewMessageCount];
    
//    [self.tableHeaderView updateWithFriends:[FRUserManager sharedInstance].currentUser.friends.allObjects];
}

- (void)showAddUsers {
    [self.eventHandler showAddUser];
}


#pragma mark - User Interface

- (void)updateDataSource:(FRMessagerDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (void)selectedUser:(UserEntity*)user {
    [self.eventHandler selectedUser:user];
}

- (void)updateChats:(NSArray*)chats {
    [self.controller updateChats:chats];
}
#pragma mark - FRTableController Delegate

- (id)objectForIndexPath:(NSIndexPath*)indexPath {
    return  [self.friendsFRC objectAtIndexPath:indexPath];
}

- (NSInteger)countObject {
    return self.friendsFRC.fetchedObjects.count;
}

- (void)updateAvailableFriends {
    [self.eventHandler updateAvailableFriends:self.friendsFRC.fetchedObjects.count];
}


#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    self.contentView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 300, 0);
    return true;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.controller updateForSearch:searchText];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    self.contentView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);

    [searchBar resignFirstResponder];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

@end
