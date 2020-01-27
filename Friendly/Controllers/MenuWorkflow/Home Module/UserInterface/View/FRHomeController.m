//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeController.h"
#import "FRHomeDataSource.h"
#import "FREvent.h"
#import "FREventsCell.h"
#import "FRHomeFriendsEventsSectionHeader.h"
#import "FRAdvertisementCell.h"
#import "Filter.h"
#import "FREventExtensionAdCell.h"
#import "FRHomeEmptyNearbyCell.h"
#import "FRDateManager.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>

@interface FRHomeController () <UITableViewDelegate, UITableViewDataSource, FRHomeFriendsEventsSectionHeaderDelegate, NSFetchedResultsControllerDelegate, FBNativeAdsManagerDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSFetchedResultsController* frc;
@property (nonatomic, strong) FRHomeEmptyNearbyCell* emptyNearbyCell;
@property (nonatomic, strong) FBNativeAdTableViewAdProvider* adsNativeProvider;
@property (nonatomic, strong) FBNativeAdsManager* nativeAdsManager;

@property (nonatomic, strong) NSIndexPath* lastIndex;
@property (nonatomic, assign) BOOL canLoadOldEvents;

@end


@implementation FRHomeController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
    
//        NSArray* testDevices = @[@"b96bd98fbd65ea9208cffa3455713f9cb4240228", @"7a48969f582f9414cf3c92f219b782176f4d0dc3"];
//        [FBAdSettings addTestDevices:testDevices];
//        [FBAdSettings clearTestDevices];
        
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[FREventsCell class] forCellReuseIdentifier:@"FREventsCell"];
        [tableView registerClass:[FREventExtensionAdCell class] forCellReuseIdentifier:@"FREventExtensionAdCell"];
        [tableView registerClass:[FRHomeFriendsEventsSectionHeader class] forHeaderFooterViewReuseIdentifier:@"FRHomeFriendsEventsSectionHeader"];
        [tableView registerClass:[FRAdvertisementCell class] forCellReuseIdentifier:@"FRAdvertisementCell"];
        
        tableView.rowHeight = 235;
        
        [tableView registerNib:[UINib nibWithNibName:@"FRHomeEmptyNearbyCell" bundle:nil] forCellReuseIdentifier:@"FRHomeEmptyNearbyCell"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateFRC) name:@"UpdateFilter" object:nil];
        
        self.emptyNearbyCell = [self.tableView dequeueReusableCellWithIdentifier:@"FRHomeEmptyNearbyCell"];
        @weakify(self);
        [[self.emptyNearbyCell.addFriends rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate addFriends];
        }];
        
        
        [self nativeAdsManager];
    }
    return self;
}

- (NSFetchedResultsController*)frc {
    if (!_frc) {

        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isDelete == %@ AND event_start > %@", @(false), [NSDate date]];
        
        _frc = [FREvent MR_fetchAllSortedBy:@"createdAt" ascending:YES withPredicate:predicate groupBy:nil delegate:self];
        
        [self updateFRC]; 
    }
    
    return _frc;
}


- (NSPredicate*)predicateWithFilter:(NSSortDescriptor **)sort {
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    Filter* filter = [context objectWithID:[[FRUserManager sharedInstance].currentUser filter].objectID];
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isDelete == %@ AND creator != NIL AND event_start > %@", @(false), [NSDate date]];
    
    
    if ([filter ageMax] && [filter ageMin]) {
        
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"ageMin >= %@ AND ageMax <= %@",[filter ageMin], [filter ageMax]]]];
    }
    if (filter && [filter gender].integerValue != 0) {
        
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"gender == %@", [filter gender]]]];
    }
    
    NSInteger distance = [[filter distance] integerValue] * 1000;
    
    if (distance > 0) {
        
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                     @[predicate, [NSPredicate predicateWithFormat:@"way <= %@", @(distance)]]];
    } else {
        predicate = [NSCompoundPredicate andPredicateWithSubpredicates:
                     @[predicate, [NSPredicate predicateWithFormat:@"way <= %@", @60000]]];
    }
    
   
    
    if (filter.sortByDate.integerValue == 0) {
        *sort = [NSSortDescriptor sortDescriptorWithKey:@"event_start" ascending:false];
    } else {
        *sort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:false];
    }
    
    
    if ([filter date]) {
        
        NSArray* weekend = [FRDateManager getThisWeekend];
        
        NSDate* first = weekend.firstObject;
        NSDate* second = weekend.lastObject;
                
        NSDate* thisWeek = [NSDate dateWithTimeIntervalSince1970:[FRDateManager getThisWeek].timeIntervalSince1970];
        switch ([[filter date] integerValue]) {
                
            case 0:
                break;
            case 1:
                
                predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"event_start >= %@ AND event_start <= %@", first, second]]];
                break;
            case 2:
                
                
                predicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[predicate, [NSPredicate predicateWithFormat:@"event_start <= %@", thisWeek]]];
                break;
            default: break;
        }
        
    }
    return predicate;
}

- (void)updateFRC {
    
     BSDispatchBlockToMainQueue(^{
         
         
    NSSortDescriptor* sort;

         
    [self.frc fetchRequest].predicate = [self predicateWithFilter:&sort];
    [[self.frc fetchRequest] setSortDescriptors:@[sort, [NSSortDescriptor sortDescriptorWithKey:@"eventId" ascending:true]]];
    
    
        NSError* error;
        [self.frc performFetch:&error];
        [self.tableView reloadData];
    });

}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(nullable NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(nullable NSIndexPath *)newIndexPath {
    
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.delegate changePositionY:scrollView.contentOffset.y];
}


#pragma mark - FRHomeFriendsEventsSectionHeaderDelegate

- (void)pressFriendsEvents
{
    [self.delegate friendsEventSelected];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.frc.fetchedObjects.count - 1 inSection:0];
    if (![self.lastIndex isEqual:indexPath]) {
        self.canLoadOldEvents = true;
        self.lastIndex = indexPath;
    }
    
    return self.frc.fetchedObjects.count ? self.frc.fetchedObjects.count : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:self.lastIndex] && self.canLoadOldEvents) {
        
        self.canLoadOldEvents = false;
        [self.delegate updateOldEvent];
        
    }
    
    if (!self.frc.fetchedObjects.count) {
        return  self.emptyNearbyCell;
    }
    
    if ([self canShowAdvertisementForIndexPath:indexPath]) {
        return [tableView dequeueReusableCellWithIdentifier:@"FREventExtensionAdCell" forIndexPath:indexPath];
    }
    
    return [tableView dequeueReusableCellWithIdentifier:@"FREventsCell" forIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.frc.fetchedObjects.count) {
        return;
    }
    
    FREvent* event = [self.frc objectAtIndexPath:indexPath];
    FREventsCellViewModel* model = [FREventsCellViewModel initWithEvent:event];
    NSLog(@"%@",event.eventId);
    model.delegate = self.delegate;
    
    if ([cell isKindOfClass:[FREventExtensionAdCell class]])
    {
        [((FREventExtensionAdCell*)cell) updateWithModel:model];
        
        BSDispatchBlockToBackgroundQueue(^{
        
            
            FBNativeAd* nativeAd = [self.adsNativeProvider tableView:tableView nativeAdForRowAtIndexPath:indexPath];
            
            BSDispatchBlockToMainQueue(^{
        
                [((FREventExtensionAdCell*)cell).contentAdView nativeAdDidLoad:nativeAd];
            });
        });

        
        return;
    }
    
    FREventsCell* evCell = (FREventsCell*)cell;
   
    [evCell updateWithModel:model];
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
     FRHomeFriendsEventsSectionHeaderViewModel* viewModel = [FRHomeFriendsEventsSectionHeaderViewModel new];
    
    if (viewModel.users.count > 0) {
        
        FRHomeFriendsEventsSectionHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FRHomeFriendsEventsSectionHeader"];
        
        [header update:viewModel];
        viewModel.delegate = self;
        
        return header;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.frc.fetchedObjects.count == 0) {
        return  self.tableView.frame.size.height - 100;
    }
    
    if ([self canShowAdvertisementForIndexPath:indexPath]) {
        
        return 490;
    }
    
    return 235;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
     FRHomeFriendsEventsSectionHeaderViewModel* viewModel = [FRHomeFriendsEventsSectionHeaderViewModel new];
    if (viewModel.users.count > 0) {
        return 70;
    }
    
    return 0;
}

- (BOOL)canShowAdvertisementForIndexPath:(NSIndexPath*)indexPath {
    return
    [FRUserManager sharedInstance].canShowAdvertisement &&
    indexPath.row % 4  == 0 &&
    indexPath.row != 0 &&
    self.nativeAdsManager.isValid;
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (FBNativeAdsManager*)nativeAdsManager {
    if (!_nativeAdsManager) {
        _nativeAdsManager = [[FBNativeAdsManager alloc] initWithPlacementID:PLACEMENT_ID forNumAdsRequested:5];
        _nativeAdsManager.mediaCachePolicy = FBNativeAdsCachePolicyCoverImage;
        _nativeAdsManager.delegate = self;
        [_nativeAdsManager loadAds];
    }
    return _nativeAdsManager;
}


- (void)nativeAdsLoaded {
    
}
 
- (void)nativeAdsFailedToLoadWithError:(NSError *)error {
    
    NSLog(@"%@", error.localizedDescription);
    BSDispatchBlockAfter(30, ^{
        
        [self.nativeAdsManager loadAds];
    });
}


- (FBNativeAdTableViewAdProvider*)adsNativeProvider {
    if (!_adsNativeProvider){
        
        _adsNativeProvider = [[FBNativeAdTableViewAdProvider alloc]initWithManager:self.nativeAdsManager];
    }
    
    return _adsNativeProvider;
}
@end
