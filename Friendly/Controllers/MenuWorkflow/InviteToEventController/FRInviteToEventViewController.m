//
//  FRInviteToEventViewController.m
//  Friendly
//
//  Created by User on 29.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInviteToEventViewController.h"
#import "UIImageHelper.h"
#import "FRStyleKit.h"
#import "FRInviteToEventEventCell.h"
#import "FRCreateEventWireframe.h"
#import "FREventTransport.h"
#import "BSHudHelper.h"
#import "FRRequestTransport.h"

@interface FRInviteToEventViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) NSMutableArray* eventsArray;

@end

static NSString* kCell = @"EventCell";

@implementation FRInviteToEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.titleLabel.text = @"Invite to event";
    [self.closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AAF"]] forState:UIControlStateNormal];
    [self tableView];
    [self.tableView registerClass:[FRInviteToEventEventCell class] forCellReuseIdentifier:kCell];
    [self.view sendSubviewToBack:self.tableView];
    [self separator];
    self.eventsArray = [NSMutableArray new];
}

- (void)getData
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FREventTransport getHostingEventWithSuccess:^(NSArray<FREvent*>* events)
    {
        [self.eventsArray addObjectsFromArray:[FRUserManager sharedInstance].currentUser.hostingEvents.allObjects];
//        NSArray* modelsArray = models.events;
//        [self.eventsArray addObjectsFromArray:events];
        [FREventTransport getJoingEventWithSuccess:^(NSArray<FREvent*>* events)
        {
            [self.eventsArray addObjectsFromArray:[FRUserManager sharedInstance].currentUser.joingEvents.allObjects];
//            NSArray* modelsArray = [NSArray arrayWithObjects:models, nil];
//            [self.eventsArray addObjectsFromArray:events];
            [self.tableView reloadData];
            [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        } failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
        }];
    }
        failure:^(NSError *error) {
            [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
}


#pragma mark - TableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.eventsArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    if (indexPath.row == self.eventsArray.count)
    {
        FRInviteToEventEventCell *eventNewCell= (FRInviteToEventEventCell*)[tableView dequeueReusableCellWithIdentifier:kCell];
        eventNewCell.selectionStyle = UITableViewCellSelectionStyleNone;
        [eventNewCell updateToLastCell];
        returnCell = eventNewCell;
    }
    else
    {
        FRInviteToEventEventCell *eventCell= (FRInviteToEventEventCell*)[tableView dequeueReusableCellWithIdentifier:kCell];
        [eventCell updateWithModel:[self.eventsArray objectAtIndex:indexPath.row]];
//        UIView *bgColorView = [[UIView alloc] init];
//        bgColorView.backgroundColor = [UIColor bs_colorWithHexString:@"#EAEDF2"];
//        [eventCell setSelectedBackgroundView:bgColorView];
        returnCell = eventCell;
    }
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.row == self.eventsArray.count)
    {
        FRCreateEventWireframe *createWF = [FRCreateEventWireframe new];
        [createWF presentCreateEventControllerFromNavigationController:self event:nil animation:YES];
    }
    else
    {
        FREvent* model = [self.eventsArray objectAtIndex:indexPath.row];
        [FRRequestTransport sendInviteToEvent:model.eventId toUserId:self.userId success:^{
            [self dismissViewControllerAnimated:YES completion:nil];
//            UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Success!", nil) message:FRLocalizedString(@"Invite sent", nil) preferredStyle:UIAlertControllerStyleAlert];
//            
//            
//            UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                
//                
//            }];
//            
//            [alertController addAction:accept];
//            [self presentViewController:alertController animated:true completion:nil];//            [self dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            //
        }];
    }
}


#pragma mark - LazyLoad

-(UITableView*) tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-15);
            make.top.equalTo(self.toolbar.mas_bottom).offset(13);
        }];
        
    }
    return _tableView;
}

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.toolbar addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.toolbar);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}


@end
