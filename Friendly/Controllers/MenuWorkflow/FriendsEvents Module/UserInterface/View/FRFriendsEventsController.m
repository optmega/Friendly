//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsController.h"
#import "FRFriendsEventsDataSource.h"
#import "FREventsCell.h"
#import "FRFriendsEventsSectionHeader.h"
#import "FRAdvertisementCell.h"
#import "FREventExtensionAdCell.h"
#import <FBAudienceNetwork/FBAudienceNetwork.h>


@interface FRFriendsEventsController () <UITableViewDelegate, UITableViewDataSource, FRInviteFriendsCellViewModelDelegate, NSFetchedResultsControllerDelegate, FBNativeAdsManagerDelegate>

@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) NSFetchedResultsController* frc;
@property (nonatomic, strong) FBNativeAdTableViewAdProvider* adsNativeProvider;
@property (nonatomic, strong) FBNativeAdsManager* nativeAdsManager;

@property (nonatomic, strong) NSIndexPath* lastIndex;
@property (nonatomic, assign) BOOL canLoadOldEvents;

@end


@implementation FRFriendsEventsController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        self.tableView = tableView;
        tableView.delegate = self;
        tableView.dataSource = self;
        [tableView registerClass:[FREventsCell class] forCellReuseIdentifier:@"FREventsCell"];
        [tableView registerClass:[FREventExtensionAdCell class] forCellReuseIdentifier:@"FREventExtensionAdCell"];
        [tableView registerClass:[FRFriendsEventsSectionHeader class] forHeaderFooterViewReuseIdentifier:@"FRFriendsEventsSectionHeader"];
        [tableView registerClass:[FRAdvertisementCell class] forCellReuseIdentifier:@"FRAdvertisementCell"];

        tableView.rowHeight = 235;
        
        [self nativeAdsManager];
    }
    return self;
}


- (NSFetchedResultsController*)frc {
    if (!_frc) {
        //NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isDelete == %@", @(false)];
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"isDelete == %@ && creator in %@", @(false), [FRUserManager sharedInstance].currentUser.friends];
        
        
        _frc = [FREvent MR_fetchAllSortedBy:@"createdAt" ascending:YES withPredicate:predicate groupBy:nil delegate:self];
    }
    
    return _frc;
}



#pragma mark - FRInviteFriendsCellViewModelDelegate

- (void)inviteFriendsSelected
{
    [self.delegate selectedFriendsInvite];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:self.frc.fetchedObjects.count - 1 inSection:0];
    if (![self.lastIndex isEqual:indexPath]) {
        self.canLoadOldEvents = true;
        self.lastIndex = indexPath;
    }
    
    
    return self.frc.fetchedObjects.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self canShowAdvertisementForIndexPath:indexPath]) {
        
        FREventExtensionAdCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FREventExtensionAdCell" forIndexPath:indexPath];
        
        return cell;
    }
    
    FREventsCell* cell = [tableView dequeueReusableCellWithIdentifier:@"FREventsCell" forIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FREvent* event = [self.frc objectAtIndexPath:indexPath];
    FREventsCellViewModel* model = [FREventsCellViewModel initWithEvent:event];
    
    model.delegate = self.delegate;
    
    if ([cell isKindOfClass:[FREventExtensionAdCell class]])
    {

        [((FREventExtensionAdCell*)cell) updateWithModel:model];

        FBNativeAd* nativeAd = [self.adsNativeProvider tableView:tableView nativeAdForRowAtIndexPath:indexPath];
        
        [((FREventExtensionAdCell*)cell).contentAdView nativeAdDidLoad:nativeAd];
        
        return;
    }
    
    FREventsCell* evCell = (FREventsCell*)cell;
    
    [evCell updateWithModel:model];

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    FRFriendsEventsSectionHeader* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FRFriendsEventsSectionHeader"];
    FRInviteFriendsCellViewModel* model = [FRInviteFriendsCellViewModel new];
    
    model.delegate = self;
    [header updateWithModel:model];

    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self canShowAdvertisementForIndexPath:indexPath]) {
        
        return 490;
    }
    
    return 235;
}

- (BOOL)canShowAdvertisementForIndexPath:(NSIndexPath*)indexPath {
    return
    [FRUserManager sharedInstance].canShowAdvertisement &&
    indexPath.row % 5 == 0 &&
    indexPath.row != 0 &&
    self.nativeAdsManager.isValid;
}

- (FBNativeAdsManager*)nativeAdsManager {
    if (!_nativeAdsManager) {
        _nativeAdsManager = [[FBNativeAdsManager alloc] initWithPlacementID:PLACEMENT_ID forNumAdsRequested:5];
        _nativeAdsManager.mediaCachePolicy = FBNativeAdsCachePolicyAll;
        _nativeAdsManager.delegate = self;
        [_nativeAdsManager loadAds];
    }
    return _nativeAdsManager;
}


- (FBNativeAdTableViewAdProvider*)adsNativeProvider {
    if (!_adsNativeProvider){
        
        _adsNativeProvider = [[FBNativeAdTableViewAdProvider alloc]initWithManager:self.nativeAdsManager];
    }
    
    return _adsNativeProvider;
}


#pragma mark - FBNativeAdsManagerDelegate

- (void)nativeAdsLoaded {
    
}

- (void)nativeAdsFailedToLoadWithError:(NSError *)error {
    
    NSLog(@"%@", error.localizedDescription);
    BSDispatchBlockAfter(30, ^{
        
        [self.nativeAdsManager loadAds];
    });
}


@end
