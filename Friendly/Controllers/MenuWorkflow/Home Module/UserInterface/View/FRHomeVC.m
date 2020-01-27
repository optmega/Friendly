//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeVC.h"
#import "FRHomeController.h"
#import "FRHomeDataSource.h"
#import "UIScrollView+BottomRefreshControl.h"
#import "FRHomeNavigationBarView.h"
#import "FRHomeEventTableHeaderView.h"
#import "FREvent.h"
#import "FRLoaderView.h"
#import "SVPullToRefresh.h"
#import "CMPopTipView.h"
#import "FRRequestAccessVC.h"
#import "FRHomeEvenTableHeader.h"
#import "FREventsCell.h"
#import "FRSettingsTransport.h"
#import "FRUploadManager.h"


@import FBAudienceNetwork;


@interface FRHomeVC () <FRHomeControllerDelegate, FREventsCellViewModelDelegate, FBNativeAdDelegate, CMPopTipViewDelegate>

@property (nonatomic, strong) FRHomeController* controller;
@property (nonatomic, strong) UIRefreshControl* topRefresh;
@property (nonatomic, strong) FRHomeNavigationBarView* navBar;
@property (nonatomic, strong) FRHomeEventTableHeader* tableHeader;
@property (nonatomic, strong) FRLoaderView* loader1View;

@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;

@property (nonatomic, strong) UIView* emptyView;

@property (nonatomic, strong) CMPopTipView* searchHelperView;
@property (nonatomic, strong) CMPopTipView* createEventHelperView;
@property (nonatomic, strong) UIView* createView;

@property (nonatomic, strong) UILabel* titleSearch;

@property (weak, nonatomic) FBMediaView *adCoverMediaView;
//@property (nonatomic, strong) UIRefreshControl* bottomFefresh;
@property FBNativeAd *nativeAd;
@property FBAdChoicesView *adChoicesView;
@property (nonatomic, assign) BOOL canShowSearchPopTip;


@end

static CGFloat const kHeaderSectionHeight = 44;

@implementation FRHomeVC

- (void)showNativeAd
{
//    _nativeAd = [[FBNativeAd alloc] initWithPlacementID:@"YOUR_PLACEMENT_ID"];
//    _nativeAd.delegate = self;
//    _nativeAd.mediaCachePolicy = FBNativeAdsCachePolicyVideo;
//    [_nativeAd loadAd];
}

- (void)nativeAdDidLoad:(FBNativeAd *)nativeAd
{
//    [self.adTitleLabel setText:nativeAd.title];
//    [self.adBodyLabel setText:nativeAd.body];
//    [self.adSocialContextLabel setText:nativeAd.socialContext];
//    [self.adCallToActionButton setTitle:nativeAd.callToAction
//                               forState:UIControlStateNormal];
    
    [nativeAd.icon loadImageAsyncWithBlock:^(UIImage *image) {
//        [self.adIconImageView setImage:image];
    }];
    
    [self.adCoverMediaView setNativeAd:nativeAd];
    
    // Add adChoicesView
    _adChoicesView = [[FBAdChoicesView alloc] initWithNativeAd:nativeAd];
//    [self.adView addSubview:adChoicesView];
//    [adChoicesView updateFrameFromSuperview];
    
    // Register the native ad view and its view controller with the native ad instance
    [nativeAd registerViewForInteraction:self.view withViewController:self];
}


- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRHomeController alloc] initWithTableView:self.tableView];
        self.controller.delegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateEvents) name:@"Location update" object:nil];
    }
    return self;
}

- (void)updateEvents {
    [self.eventHandler updateNewEvent];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableHeader startTimer];
    
    self.view.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
    
    [self showNativeAd];
    
//    [self updateFeatured:nil];
    
//    [self updateBanner];
    
    [self titleSearch];
    self.tableView.backgroundColor = [UIColor clearColor];
    BSDispatchBlockAfter(2, ^{
        
        if (self.canShowSearchPopTip)
        {
            [self searchHelperView];
        }
      
        if (![[NSUserDefaults standardUserDefaults] objectForKey:kCreateEventHelperFirstTime]) {
            [self createEventHelperView];
        }
    });
    
    
    if (![USER_DEFAULTS objectForKey:REQUEST_LOCATION_WAS_CARRIED_OUT])
    {
        [USER_DEFAULTS setObject:@"REQUEST_LOCATION_WAS_CARRIED_OUT" forKey:REQUEST_LOCATION_WAS_CARRIED_OUT];
        
        FRRequestAccessVC* requestVC =  [FRRequestAccessVC new];
        requestVC.mode = FRRequestAccessViewLocation;
        [self presentViewController:requestVC animated:YES completion:nil];
    }
    

    self.heightInset = 0;
    [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((64 + self.heightInset)));
    }];
    self.navBar.alpha = 1;
    
    
    
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
//    self.bottomFefresh = [[UIRefreshControl alloc] init];
//    self.bottomFefresh.alpha = 0;
//    self.bottomFefresh.triggerVerticalOffset = 1;
//    [self.bottomFefresh addTarget:self action:@selector(bottomRefresh:) forControlEvents:UIControlEventValueChanged];
//    self.tableView.bottomRefreshControl = self.bottomFefresh;
    
    [self.eventHandler willApear];
    [APP_DELEGATE sendToGAScreen:@"HomeScreen"];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.tableHeader stopTimer];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.canShowSearchPopTip = ([[NSUserDefaults standardUserDefaults] objectForKey:kSearchHelperFirstTime] == nil);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addLoadView:) name:SHOW_UPLOAD_VIEW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dismissCreateTooltip) name:@"createEventHelperView" object:nil];
    
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
    
    [self updateBanner];
    self.view.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
    
    [self.navBar title];
    
    @weakify(self);
    [[self.navBar.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler showSearchEvents];
        [[NSUserDefaults standardUserDefaults] setObject:@(true) forKey:kSearchHelperFirstTime];
        self.canShowSearchPopTip = false;
        [self.searchHelperView removeFromSuperview];
    }];
    
    [[self.navBar.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler showFilter];
    }];
    
    self.tableHeader = [[FRHomeEventTableHeader alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 400)];
    self.tableHeader.delegate = self;
//    [self updateFeatured:nil];
    
    
    CGRect footerFrame = self.tableHeader.bounds;
    footerFrame.size.height = 0.001;
    UIView* footerView = [[UIView alloc]initWithFrame:footerFrame];
    self.tableView.tableFooterView = footerView;
    
    [self.view bringSubviewToFront:self.navBar];
    [self setupRefresh];
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.001)];
    
    
    self.createView = [UIView new];
    [self.view addSubview:self.createView];
    [self.createView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.centerX.equalTo(self.view);
        make.height.width.equalTo(@1);
    }];
    
    BSDispatchBlockAfter(3, ^{
        [self.tableHeader startTimer];

    });
    
    
    self.view.alpha = 0;
    [UIView animateWithDuration:1.0 animations:^{
        self.view.alpha = 1;
    }];
}

- (void)dismissCreateTooltip {
    
    [self.createEventHelperView dismissAnimated:true];
}

- (void)addLoadView:(NSNotification*)notification {
    [self.view addSubview:notification.object];
}

- (void)addFriends {
    [self.eventHandler showAddFriends];
}


- (void)updateFeatured:(NSArray*)eventEntity
{
    BSDispatchBlockToMainQueue(^{
        
        
    [self.topRefresh endRefreshing];
        
        @weakify(self);
        BSDispatchBlockAfter(0.5, ^{
    
            
            
            
                @strongify(self);
                
//                NSFetchRequest* fetch = [NSFetchRequest fetchRequestWithEntityName:@"FREvent"];
//                fetch.fetchLimit = 1;
//                
                
//                NSSortDescriptor* sort;
//                 fetch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[[self.controller predicateWithFilter:&sort], [NSPredicate predicateWithFormat:@"eventType == %@", @(FREventTypeFeatured)]]];
//            
//                fetch.sortDescriptors = @[sort, [NSSortDescriptor sortDescriptorWithKey:@"eventId" ascending:true]];
            
            
                NSArray* featuredEvents = eventEntity;//[FREvent MR_executeFetchRequest:fetch];
                [self.tableHeader updateWithModels:featuredEvents];
            
                
                [self.tableView beginUpdates];
                
                [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
                
                if (featuredEvents.count)
                {
                    self.tableView.tableHeaderView = self.tableHeader;
                } else {
                    self.tableView.tableHeaderView = self.emptyView;
                }
            
            
            if (featuredEvents.count < 2) {
                [self.tableHeader stopTimer];
            } else {
                [self.tableHeader startTimer];
            }
                [UIView animateWithDuration:.3f animations:^{
                    
                    @strongify(self);
                    if (featuredEvents.count)
                    {
                        self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 400);
                    } else {
                        self.tableView.tableHeaderView.bounds = CGRectMake(0, 0, self.tableView.bounds.size.width, 0.01);
                    }
                    
                } completion:^(BOOL finished) {
                    @strongify(self);
                    @try {
                        
                        
                        [self.tableView endUpdates];
                    } @catch (NSException *exception) {
                    } @finally {
                        [self.tableView reloadData];
                    
                    }
                    
                }];
            });
        
    
    self.tableHeader.userInteractionEnabled = true;
        
        });
}

- (void)setupRefresh
{
    self.topRefresh = [[UIRefreshControl alloc] init];
    self.topRefresh.tintColor = [UIColor whiteColor];
    [self.topRefresh addTarget:self action:@selector(topRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.topRefresh];
    
    [self.tableView bringSubviewToFront:self.topRefresh];
    
    self.tableView.backgroundView.layer.zPosition -= 1;
    self.topRefresh.layer.zPosition +=1;

}

- (void)topRefresh:(UIRefreshControl*)sender {
    self.tableHeader.userInteractionEnabled = false;
    [self.eventHandler updateNewEvent];
}

- (void)bottomRefresh:(UIRefreshControl*)sender {
    [self.eventHandler updateOldEvent];
}

- (void)updateOldEvent {
    [self.eventHandler updateOldEvent];
}

- (void)changePositionY:(CGFloat)y
{
    
    if (self.tableView.tableHeaderView)
    {
        [self.tableHeader changePositionY:y];
    }
    
    UIScrollView* scrollView = self.tableView;
    
    if (self.tableView.contentSize.height < self.screenHeight)
    {
        return;
    }
    
    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
    
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) >= scrollView.contentSize.height || scrollView.contentOffset.y <= 0)
    {
        return;
    }
    
    if (self.lastOffsetY > scrollView.contentOffset.y && (self.heightInset < 0))
    {
        self.heightInset += (self.lastOffsetY - scrollView.contentOffset.y);
        self.heightInset = self.heightInset > 0 ? 0 : self.heightInset;
    }
    
    else if (self.lastOffsetY < scrollView.contentOffset.y && (self.heightInset >= - sectionHeaderHeight))
    {
        self.heightInset -= (scrollView.contentOffset.y - self.lastOffsetY );
        self.heightInset = self.heightInset < -sectionHeaderHeight ? -sectionHeaderHeight : self.heightInset;
    }
    
    CGFloat opacity = (44. + self.heightInset) / 44.;
    
    if (-scrollView.contentInset.top >= 2 )
    {
        opacity /= 2;
    }
    
    self.navBar.alpha = opacity;
    [self.navBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@((64 + self.heightInset)));
    }];
    self.lastOffsetY = scrollView.contentOffset.y;
    
    if (self.heightInset == 0)
    {
        if (self.canShowSearchPopTip) {
            
            [self.searchHelperView presentPointingAtView:self.navBar.rightButton inView:self.view animated:true];
        }
    } else {
        
        [self.searchHelperView dismissAnimated:true];
    }
}

#pragma mark - User Interface

- (void)updateDataSource:(FRHomeDataSource *)dataSource
{
}

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)updatedEvents
{
    
//    [self.tableView.bottomRefreshControl endRefreshing];
    [self.topRefresh endRefreshing];
    
//    [self updateFeatured:nil];
    self.tableHeader.userInteractionEnabled = true;
}

- (UILabel*)titleSearch
{
    if (!_titleSearch)
    {
//        _titleSearch = [UILabel new];
//        _titleSearch.textColor = [UIColor bs_colorWithHexString:@"#AEB3C4"];
////        _titleSearch.text = @"Looking for events";
//        
//        [self.view addSubview:_titleSearch];
//        [self.view bringSubviewToFront:self.tableView];
//        [_titleSearch mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.center.equalTo(self.view);
//        }];
    }
    return _titleSearch;
}
- (void)updateBanner
{
//    [_banner removeFromSuperview];
//    [_bannerTwo removeFromSuperview];
//  
//        _banner = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
//        _banner.adUnitID = GOOGLE_Ad_UNID_ID;
//        _banner.rootViewController = self;
//        
//        GADRequest *r = [[GADRequest alloc] init];
//        r.testDevices = TEST_DEVICE_ARRAY;
//        [_banner loadRequest:r];
//    
//    _bannerTwo = [[DFPBannerView alloc] initWithAdSize:kGADAdSizeMediumRectangle];
//    _bannerTwo.adUnitID = GOOGLE_Ad_UNID_ID;
//    _bannerTwo.rootViewController = self;
//    
//    GADRequest *r1 = [[GADRequest alloc] init];
//    r1.testDevices = TEST_DEVICE_ARRAY;
//    [_bannerTwo loadRequest:r1];
    
}


- (CMPopTipView*)searchHelperView
{
    if (!_searchHelperView)
    {
        _searchHelperView = [[CMPopTipView alloc] initWithTitle:nil message:@"    Browse events by categories or in map view  "];
        _searchHelperView.delegate = self;
        _searchHelperView.pointerSize = 5;
        _searchHelperView.cornerRadius = 5;
        _searchHelperView.has3DStyle = false;
        
        _searchHelperView.textColor = [UIColor whiteColor];
        _searchHelperView.hasGradientBackground = false;
        
        if ([[UIScreen mainScreen] bounds].size.height >= 667.f) {
            
            _searchHelperView.textFont = FONT_PROXIMA_NOVA_MEDIUM(15);
            _searchHelperView.maxWidth = 340;
        } else {
            
            _searchHelperView.textFont = FONT_PROXIMA_NOVA_MEDIUM(13);
            _searchHelperView.maxWidth = 300;
        }
        _searchHelperView.borderColor = [UIColor clearColor];
        _searchHelperView.backgroundColor = [UIColor bs_colorWithHexString:@"00B5FF"];
        _searchHelperView.bubblePaddingY = 8;
        _searchHelperView.sidePadding = 10;
        [_searchHelperView presentPointingAtView:self.navBar.rightButton inView:self.view animated:true];
    }
    return _searchHelperView;
}

- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    if ([popTipView isEqual:self.searchHelperView]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"kSearchHelperFirstTime" forKey:kSearchHelperFirstTime];
        self.canShowSearchPopTip = false;
    }
}

- (CMPopTipView*)createEventHelperView
{
    if (!_createEventHelperView)
    {
        _createEventHelperView = [[CMPopTipView alloc] initWithTitle:nil message:@"   Click here to create your first event   "];
        _createEventHelperView.pointerSize = 5;
        _createEventHelperView.cornerRadius = 5;
        _createEventHelperView.has3DStyle = false;
        _createEventHelperView.textFont = FONT_PROXIMA_NOVA_MEDIUM(15);
        _createEventHelperView.textColor = [UIColor whiteColor];
        _createEventHelperView.hasGradientBackground = false;
        _createEventHelperView.maxWidth = 300;
        _createEventHelperView.borderColor = [UIColor clearColor];
        _createEventHelperView.backgroundColor = [UIColor bs_colorWithHexString:@"00B5FF"];
        _createEventHelperView.bubblePaddingY = 8;
        
        [_createEventHelperView presentPointingAtView:self.createView inView:self.view animated:true];
    }
    return _createEventHelperView;
}

#pragma mark - LazyLoad

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableHeader.clipsToBounds = false;
        _tableView.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = false;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
    }
    return _tableView;
}

- (FRHomeNavigationBarView*)navBar
{
    if (!_navBar)
    {
        _navBar = [FRHomeNavigationBarView new];
        [self.view addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}


#pragma mark - FRTableController Delegate

- (void)friendsEventSelected
{
    [self.eventHandler showFriendsEvents];
}


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
    
    [self.tableHeader stopTimer];
    
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:viewModel.cell]];
    
    cellRect = CGRectOffset(cellRect, -self.tableView.contentOffset.x, -self.tableView.contentOffset.y);
    
    FREventsCell* cell = (FREventsCell*)viewModel.cell;
    
    cellRect.size = cell.eventImage.frame.size;
    cellRect.origin.y += self.tableView.frame.origin.y + 10;
    
    
    
    if (!cell) {
        cellRect = CGRectMake(self.tableView.contentOffset.x, -self.tableView.contentOffset.y + self.navBar.frame.size.height, [UIScreen mainScreen].bounds.size.width, 350);
    }
    
    
    self.willShowEventPreview = true;

    
    self.willShowEventPreview = true;
    [self setNeedsStatusBarAppearanceUpdate];
    [self.eventHandler selectedEvent:[viewModel domainModel] fromFrame:cellRect];
    
}

- (void)startTimer {
    [self.tableHeader startTimer];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.willShowEventPreview) {
        
        setStatusBarColor([FRUserManager sharedInstance].statusBarStyle == UIStatusBarStyleDefault ? [UIColor blackColor] : [UIColor whiteColor]);
        return [[FRUserManager sharedInstance] statusBarStyle];
    }
    
    setStatusBarColor([UIColor blackColor]);
    return  UIStatusBarStyleDefault;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
