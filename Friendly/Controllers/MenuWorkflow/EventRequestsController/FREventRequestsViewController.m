//
//  EventRequestsViewController.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsViewController.h"
#import "FREventRequestsToJoinHeader.h"
#import "FREventRequestsInviteHeader.h"
#import "FREventRequestsEventHeader.h"
#import "FREventRequestsToJoinCell.h"
#import "FREventRequestsInviteCell.h"
#import "FREventTransport.h"
#import "FREventRequestsToJoinRequestModel.h"
#import "FRFriendsTransport.h"
#import "FRRequestTransport.h"
#import "FRInviteModel.h"
#import "FRJoinEventViewController.h"
#import "FRBadgeCountManager.h"
#import "FRUserManager.h"
#import "BSHudHelper.h"
#import "FREmptyStateView.h"
#import "FREventPreviewController.h"
#import "FRTransitionAnimator.h"
#import "FRUserProfileWireframe.h"
#import "FRDateManager.h"

@interface FREventRequestsViewController() <UITableViewDataSource, UITableViewDelegate, FREventRequestsToJoinCellDelegate, FREventRequestsInviteCellDelegate, FRJoinEventViewControllerDelegate, FREventRequestsToJoinHeaderDelegate, FREventRequestsEventHeaderDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSArray* eventsArray;
@property (nonatomic, assign) NSInteger requestsArray;
@property (nonatomic, assign) NSInteger sectionsCount;
@property (nonatomic, strong) NSMutableArray* headersArray;
@property (nonatomic, strong) NSMutableArray* cellsArray;
@property (nonatomic, strong) NSMutableArray* invitesArray;
@property (nonatomic, strong) NSMutableArray* invitesToPartnerArray;
@property (nonatomic, assign) NSInteger k;
@property (nonatomic, strong) FREmptyStateView* emptyStateView;
@end

static NSString* const kJoinCellId = @"kJoinCellId";
static NSString* const kInviteCellId = @"kInviteCellId";

@implementation FREventRequestsViewController



-(void)viewWillAppear:(BOOL)animated
{
    self.emptyStateView.hidden = YES;
}

-(void)viewDidAppear:(BOOL)animated
{
    [APP_DELEGATE sendToGAScreen:@"EventRequestsScreen"];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.emptyStateView.hidden = YES;
//    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [self.titleLabel setText:@"Event requests"];
    self.invitesArray = [NSMutableArray array];
    self.invitesToPartnerArray = [NSMutableArray array];
    self.headersArray = [NSMutableArray array];
    self.cellsArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
    [self getData];
    [self tableView];
    self.k = 0;
}

- (void) getData
{
    self.emptyStateView.hidden = YES;
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [self.headersArray removeAllObjects];
    [self.cellsArray removeAllObjects];
    [self.invitesArray removeAllObjects];
    [self.invitesToPartnerArray removeAllObjects];
    [FRFriendsTransport getInvitesToEventsForMeWithSuccess:^(FRInviteModels *inviteModels) {
        self.invitesArray = [NSMutableArray arrayWithArray:inviteModels.invites];
        self.invitesToPartnerArray = [NSMutableArray arrayWithArray:inviteModels.invites_to_partner];
        [self.tableView reloadData];
        //        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        if ((self.invitesArray.count == 0)&&(self.invitesToPartnerArray.count == 0)&&(self.cellsArray.count == 0))
        {
            self.emptyStateView.hidden = NO;
        }
        else
            self.emptyStateView.hidden = YES;
        
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];

    [FREventTransport getHostingEventWithSuccess:^(NSArray<FREvent*>* events) {
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        self.eventsArray = [FRUserManager sharedInstance].currentUser.hostingEvents.allObjects;
        FREventRequestsInviteHeader *requestToJoinHeader = [FREventRequestsInviteHeader new];
        requestToJoinHeader.titleLabel.text = @"REQUEST TO JOIN";
        [self.headersArray addObject:requestToJoinHeader];
        FREvent* model = nil;
        int k = 0;
        for (int i = 0; i<self.eventsArray.count; i++)
        {
            model = self.eventsArray[i];
            NSLog(@"%@", model);
            if ((model.userRequest.count>0)&&(![FRDateManager isDateEarlierThanToday:[FRDateManager stringFromDate:model.event_start withFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS"]]))
            {
                if (k==0)
                {
                    FREventRequestsToJoinHeader *toJoinHeader = [FREventRequestsToJoinHeader new];
                    toJoinHeader.delegate = self;
                    FREventRequestsToJoinHeaderModel* headerModel =[FREventRequestsToJoinHeaderModel initWithModel:model];
                    [toJoinHeader updateWithModel:headerModel];
                    [self.headersArray replaceObjectAtIndex:0 withObject:toJoinHeader];
                    [self.cellsArray addObject:model.userRequest.allObjects];
                    k++;
                }
                else
                {
                    FREventRequestsEventHeader *eventHeader = [FREventRequestsEventHeader new];
                    eventHeader.delegate = self;
                    FREventRequestsToJoinHeaderModel* headerModel =[FREventRequestsToJoinHeaderModel initWithModel:model];
                    [eventHeader updateWithModel:headerModel];
                    [self.headersArray addObject:eventHeader];
                    [self.cellsArray addObject:model.userRequest.allObjects];
                    self.requestsArray++;
                }
            }
        }
        FREventRequestsInviteHeader *inviteHeader = [FREventRequestsInviteHeader new];
        [self.headersArray addObject:inviteHeader];
        FREventRequestsInviteHeader *inviteToCoHostHeader = [FREventRequestsInviteHeader new];
        inviteToCoHostHeader.titleLabel.text = @"INVITES TO CO-HOST AN EVENT";
        [self.headersArray addObject:inviteToCoHostHeader];
        
        [self.tableView reloadData];
        if ((self.invitesArray.count == 0)&&(self.invitesToPartnerArray.count == 0)&&(self.cellsArray.count == 0))
        {
            self.emptyStateView.hidden = NO;
        }
        else
            self.emptyStateView.hidden = YES;

        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];

    }
     
     
                                         failure:^(NSError *error) {
                                             //
                            }];
    
       }

//-(NSInteger)getRequestsCount
//{
//    [self getData];
//    return self.invitesArray.count+self.invitesToPartnerArray.count+self.cellsArray.count;
//}

#pragma mark - CellDelegate

- (void) reloadData
{
    [self getData];
    [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
}

- (void) updateRequestStatus
{
    [self getData];
}

- (void) joinEventWithId:(NSString *)eventId andModel:(FREvent *)model
{
    FRJoinEventViewController* joinVC = [FRJoinEventViewController new];
    joinVC.heightFooter = 255;
    joinVC.delegate = self;
    [joinVC updateWithEvent:model];
    [self presentViewController:joinVC animated:YES completion:nil];
}


- (void) declineEventWithId:(NSString *)eventId
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRRequestTransport declineInviteForId:eventId success:^{
        [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
            [FRUserManager sharedInstance].eventRequestsCount = count;
            [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
            [self reloadData];
        }];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];

    }];
}

-(void)acceptPartnerForEventId:(NSString*)eventId
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRRequestTransport acceptInviteToCoHostForEventId:eventId success:^{
        
        FREvent* event = [FREventTransport getEventForId:eventId success:^(FREvent *event) {
            
            if (event) {
                event = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
                [[[FRUserManager sharedInstance] currentUser] addHostingEventsObject:event];
            }
            
        } failure:^(NSError *error) {
            
        }];
        
        if (event) {
            event = [[NSManagedObjectContext MR_defaultContext] objectWithID:event.objectID];
            [[[FRUserManager sharedInstance] currentUser] addHostingEventsObject:event];
        }
        
        [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
            [FRUserManager sharedInstance].eventRequestsCount = count;
            [self reloadData];
            [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];

        }];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];

    }];
}
-(void)declinePartnerForEventId:(NSString*)eventId
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRRequestTransport declineInviteToCoHostForEventId:eventId success:^{
        [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
            [FRUserManager sharedInstance].eventRequestsCount = count;
            [self reloadData];
            [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];

        }];
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
}

-(void)acceptInviteWithId:(NSString*)inviteId
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRRequestTransport acceptInviteForInviteId:inviteId success:^{
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
            [FRUserManager sharedInstance].eventRequestsCount = count;

            [self reloadData];

        }];
       
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
}

-(void)showEventWithModel:(FREvent *)model
{
    FREventPreviewController* eventPreviewVC = [[FREventPreviewController alloc] initWithEvent:model fromFrame:CGRectZero];
    UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:eventPreviewVC];
    nv.navigationBarHidden = YES;
    
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [self presentViewController:nv animated:true completion:nil];
    
//    [[FRTransitionAnimator new] presentViewController:nv from:self];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    self.tableView.contentOffset = CGPointZero;
    FRUserProfileWireframe* uWF = [FRUserProfileWireframe new];
//    [uWF presentUserProfileControllerFromNavigationController:self.navigationController user:user withAnimation:YES];
    [uWF presentUserProfileFromViewController:self user:user fromLoginFlow:NO];
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.headersArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (section<self.cellsArray.count)
//    {
//        NSArray* array = [self.cellsArray objectAtIndex:section];
//        return array.count;
//    }
//    else 
//    {
//        return self.invitesArray.count;
//    }

    if (section == self.headersArray.count-2)
    {
        return self.invitesArray.count;
    }
    else if (section == self.headersArray.count-1)
    {
        return self.invitesToPartnerArray.count;
    }
    else if (self.cellsArray.count>0)
    {
        NSArray* array = [self.cellsArray objectAtIndex:section];
        return array.count;
    }
    else return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{

    id header = [self.headersArray objectAtIndex:section];
    if ((self.cellsArray.count == 0)&&(section == 0))
    {
        return 0;
    }
    if ((self.invitesArray.count == 0)&&(section == self.headersArray.count-2))
    {
        return 0;
    }
    if ((self.invitesToPartnerArray.count == 0)&&(section == self.headersArray.count-1))
    {
        return 0;
    }
    if ([header isKindOfClass:[FREventRequestsToJoinHeader class]])
    {
        return 105;
    }
    if ([header isKindOfClass:[FREventRequestsInviteHeader class]])
    {
        return 55;
    }
    if ([header isKindOfClass:[FREventRequestsEventHeader class]])
    {
        return 45;
    }
    else
    {
        return 0;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [self.headersArray objectAtIndex:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld", (long)indexPath.section);

    UITableViewCell* returnCell = [UITableViewCell new];
    
    FREventRequestsToJoinCell* toJoinCell = (FREventRequestsToJoinCell*)[tableView dequeueReusableCellWithIdentifier:kJoinCellId];
    FREventRequestsInviteCell* inviteCell = (FREventRequestsInviteCell*)[tableView dequeueReusableCellWithIdentifier:kInviteCellId];
    if (indexPath.section == self.headersArray.count-2)
    {
        if (self.invitesArray.count>0) {
            if (!inviteCell)
            {
                inviteCell = [[FREventRequestsInviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInviteCellId];
            }
            [inviteCell updateWithModel:[self.invitesArray objectAtIndex:indexPath.row]];
            inviteCell.delegate = self;
            returnCell = inviteCell;
        }
    }
    else if (indexPath.section == self.headersArray.count-1)
    {
        if (!inviteCell)
        {
            inviteCell = [[FREventRequestsInviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kInviteCellId];
        }
        [inviteCell updateWithInvitePartnerModel:[self.invitesToPartnerArray objectAtIndex:indexPath.row]];
        [inviteCell updateWithInviteToCoHost];
        inviteCell.delegate = self;
        returnCell = inviteCell;
    }
    else if (self.cellsArray.count>0)
    {
    if (!toJoinCell)
    {
        toJoinCell = [[FREventRequestsToJoinCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJoinCellId];
    }
        NSArray* array = [self.cellsArray objectAtIndex:indexPath.section];
        FREventRequestsToJoinRequestModel* requestModel = [FREventRequestsToJoinRequestModel initWithModel:[array objectAtIndex:indexPath.row]];
        self.k++;

        [toJoinCell updateWithModel:requestModel];
        toJoinCell.delegate = self;
        returnCell = toJoinCell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    //[toJoinCell setBackgroundColor:[UIColor blackColor]];
    //[toJoinCell updateViewModel:[self.list objectAtIndex:indexPath.row]];
    return returnCell;

}


#pragma mark - LazyLoad

-(UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        [_tableView setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
//        [_tableView registerClass:[FREventRequestsToJoinCell class] forCellReuseIdentifier:kJoinCellId];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view  addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.top.equalTo(self.toolbar.mas_bottom);
        }];
    }
    return _tableView;
}

- (FREmptyStateView*) emptyStateView
{
    if (!_emptyStateView)
    {
        _emptyStateView = [FREmptyStateView new];
        _emptyStateView.titleLabel.text = @"No event requests";
        _emptyStateView.subtitleLabel.text = @"When users ask to join or invite you to\ntheir event, it will appear here";
        [self.view addSubview:_emptyStateView];
        [self.view insertSubview:_emptyStateView aboveSubview:self.tableView];
        [_emptyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    return _emptyStateView;
}

- (void)updateRequestStatusWithModel:(FREvent *)event {
    
}

@end
