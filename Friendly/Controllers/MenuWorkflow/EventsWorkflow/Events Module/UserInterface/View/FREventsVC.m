//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsVC.h"
#import "FREventsController.h"
#import "FREventsDataSource.h"
#import "FREventModel.h"
#import "FRRequestAccessVC.h"
#import "FRSegmentView.h"

#import "FREventsHeaderView.h"
#import "FREventsHeaderViewModel.h"


@interface FREventsVC ()
<   FREventsControllerDelegate,
    FRSegmentViewDelegate,
    FREventsHeaderViewModelDelegate,
    FRSegmentViewDelegate
>

@property (nonatomic, strong) FREventsController* controller;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* statusBackView;


@property (nonatomic, assign) CGRect cellFrameInSuperview;
@property (nonatomic, assign) CGRect cellFrameInPreviewView;
@property (nonatomic, assign) CGRect colelctionCellFrameInSuperview;
@property (nonatomic, strong) UIImageView* selectedCellImage;
@property (nonatomic, strong) UIView* whiteView;
@property (nonatomic) BOOL isCVCell;


@property (nonatomic, assign) BOOL isWillApeareFromEventPreviewController;

@property (nonatomic, strong) FREventsHeaderView* headerView;

@end


@implementation FREventsVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FREventsController alloc] initWithTableView:self.tableView];
        self.controller.delegate = self;
        self.controller.scrollDelegate = self;
        FREventsHeaderViewModel* model = [FREventsHeaderViewModel new];
        model.searchContent = @"Search";
        model.delegate = self;
        [self.headerView updateModel:model];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self statusBackView];
    [self tableView];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(!self.isWillApeareFromEventPreviewController)
    {
        [self.eventHandler updateEvents];
    }
    self.isWillApeareFromEventPreviewController = NO;
    
    [self.headerView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    if (![USER_DEFAULTS objectForKey:REQUEST_LOCATION_WAS_CARRIED_OUT])
    {
        [USER_DEFAULTS setObject:@"REQUEST_LOCATION_WAS_CARRIED_OUT" forKey:REQUEST_LOCATION_WAS_CARRIED_OUT];
        
        FRRequestAccessVC* requestVC =  [FRRequestAccessVC new];
        requestVC.mode = FRRequestAccessViewLocation;
        [self presentViewController:requestVC animated:YES completion:nil];
    }
    
    [APP_DELEGATE sendToGAScreen:@"EventsScreen"];

    
}

- (void)selectingCell:(CGRect)attributes image:(UIImage*)image event:(FREventModel*)event firstCell:(BOOL)firstCell
{
    
    [self.eventHandler selectedEvent:event image:image];

    
//    self.isWillApeareFromEventPreviewController = YES;
//    
//    self.selectedCellImage = [UIImageView new];
//    [self.view addSubview:self.selectedCellImage];
//    CGRect frameRect = attributes;
//    frameRect.size.height = attributes.size.height - 55;
//    self.cellFrameInSuperview = frameRect;
//    self.selectedCellImage.frame = self.cellFrameInSuperview;
//    [self.selectedCellImage setImage:image];
//    self.cellFrameInPreviewView = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300);
//    self.whiteView.alpha = 0;
//    
//    [UIView animateWithDuration:0.5 animations:^{
//        self.navigationController.navigationBar.alpha = 0;
//        self.whiteView.alpha = 1;
//        self.selectedCellImage.frame = self.cellFrameInPreviewView;
//        
//    } completion:^(BOOL finished) {
//        
//        [self.eventHandler selectedEventId:eventId image:image];
//        
//    }];
//    
//    
//     self.isCVCell = firstCell;
}

- (void)updateHeaderViewForPosition:(CGFloat)positionY opacity:(CGFloat)opacity
{
    CGRect headerViewFrame = self.headerView.frame;
    headerViewFrame.origin.y = positionY;
    [self.headerView updateAlpha:opacity];
    self.headerView.frame = headerViewFrame;
}

#pragma mark - FRSegmentViewDelegate

- (void)selectedSegmentIndex:(FRSegmentType)index
{
    [self.eventHandler selectedSegment:index];
}

#pragma mark - User Interface

- (void)updateDataSource:(FREventsDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (void)refreshControlAction:(UIRefreshControl *)refreshControl
{
    // Do your job, when done:
    [self.eventHandler updateEvents];
    
    [refreshControl endRefreshing];
}


#pragma mark - FRTableController Delegate

- (FREventsHeaderView*)headerView
{
    if (!_headerView)
    {
        _headerView = [[FREventsHeaderView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width, 104)];
        _headerView.segmentView.delegate = self;
        [self.view addSubview:_headerView];
    }
    return _headerView;
}


- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.decelerationRate = 0.001;
        _tableView.contentInset = UIEdgeInsetsMake(104,0,0,0);
        _tableView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator  = NO;
        
        UIRefreshControl* refreshControl = [UIRefreshControl new];
        [refreshControl addTarget:self action:@selector(refreshControlAction:) forControlEvents:UIControlEventValueChanged];
        [_tableView addSubview:refreshControl];
        _tableView.bounces = NO;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (UIView*)statusBackView
{
    if (!_statusBackView)
    {
        _statusBackView = [UIView new];
        _statusBackView.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.view addSubview:_statusBackView];
        
        [_statusBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.view);
            make.height.equalTo(@20);
            make.top.equalTo(self.view).offset(0);
            
        }];
    }
    return _statusBackView;
}


#pragma mark - FREventsControllerDelegate


- (void)showShowUserProfileSelected
{
    [self.eventHandler showProfileVC];
}

- (void)showFilter
{
    
}

- (void)showFilterSelected
{
    [self.eventHandler showFilter];
}

- (void)moveBackAndShowVC
{
    self.selectedCellImage.frame = self.cellFrameInPreviewView;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        if (self.isCVCell)
        {
            CGRect rect = self.cellFrameInSuperview;
            rect.origin.y += 10;
            self.selectedCellImage.frame = rect;
        }
        else
        {
            CGRect rect = self.cellFrameInSuperview;
            rect.size.height -= 10;
            rect.origin.y += 10;
            self.selectedCellImage.frame = rect;
        }
         self.whiteView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedCellImage.alpha = 0;
            self.navigationController.navigationBar.alpha = 1;
        }];
    }];
}


#pragma mark - Lazy Load

- (UIView*)whiteView
{
    if (!_whiteView)
    {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.alpha = 0;
        [self.view insertSubview:_whiteView aboveSubview:self.tableView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _whiteView;
}

@end
