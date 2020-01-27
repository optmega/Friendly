//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryDataSource.h"
#import "BSMemoryStorage.h"
#import "FRSearchByCategoryMapCellViewModel.h"
#import "FRSearchByCategoryDiscoverPeopleCellViewModel.h"
#import "FRSearchByCategoryNearbyCellViewModel.h"
#import "FREventModel.h"
#import "FREventsCellViewModel.h"
#import "FRLocationManager.h"
#import "FREventsCell.h"

@import GoogleMaps;

@interface FRSearchEventByCategoryDataSource () <FRSearchByCategoryNearbyCellViewModelDelegate, FRSearchByCategoryMapCellViewModelDelegate, FREventsCellViewModelDelegate >

@property (strong, nonatomic) NSArray* users;

@end

@implementation FRSearchEventByCategoryDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage
{
    FRSearchByCategoryMapCellViewModel* mapModel = [FRSearchByCategoryMapCellViewModel new];
    mapModel.delegate = self;
    [self.storage addItem:mapModel];
    
    FRSearchByCategoryNearbyCellViewModel* nearbyCell = [FRSearchByCategoryNearbyCellViewModel new];
    nearbyCell.delegate = self;
    [self.storage addItem:nearbyCell];
    
    FRSearchByCategoryDiscoverPeopleCellViewModel* discoverPeople = [FRSearchByCategoryDiscoverPeopleCellViewModel new];
    [self.storage addItem:discoverPeople];
    
    
}

- (void)reloadModel:(FREvent*)event
{
    [self.storage reloadItem:event];
  //  [self updateStorageWithEvents:self.storage.storageArray users:self.users];

}

- (void)updateStorageWithEvents:(NSArray*)eventList users:(NSArray*)users
{
//    if (!eventList.count) {
//        return;
//    }
    self.users = [NSArray arrayWithArray:users];
    self.events = eventList;
    NSMutableArray* items = [NSMutableArray array];
    
    FRSearchByCategoryMapCellViewModel* mapModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    mapModel.markersArray = [self createMarkerFromEvents:eventList];
    mapModel.events = eventList;
    
    FRSearchByCategoryNearbyCellViewModel* nearbyCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    nearbyCell.count = eventList.count;
    FRSearchByCategoryDiscoverPeopleCellViewModel* discoverPeople = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    discoverPeople.users = users;
    [items addObjectsFromArray:@[mapModel, nearbyCell, discoverPeople]];
    [items addObjectsFromArray:[self _viewModelFromModel:eventList]];
    
    [self.storage removeAndAddNewItems:items];
}

#pragma mark - FRSearchByCategoryMapCellViewModelDelegate

- (void)selectedShowFullScreen
{
    FRSearchByCategoryMapCellViewModel* model = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.storage reloadItem:model];
}

- (void)showEventPreviewWithEvent:(id )model
{
    if ([model isKindOfClass:[FREvent class]]) {
        
        [self.delegate showEventPreviewWithEvent:model fromFrame:CGRectZero];
    } else {
        [self.delegate showUserProfile:model];
    }
}

#pragma mark - Private

- (NSArray*)createMarkerFromEvents:(NSArray*)events
{
    NSMutableArray* markers = [NSMutableArray array];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:[FRLocationManager sharedInstance].location];
//    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(2, 2, 10, 10)];
//    view.layer.cornerRadius = 5;
//    view.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
    UIImageView* bubble = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 28, 28)];
//    bubble.backgroundColor = [UIColor whiteColor];
//    [bubble addSubview:view];
    bubble.image = [UIImage imageNamed:@"mylocation"];
//    bubble.layer.cornerRadius = 7;
    marker.userData = [[NSManagedObjectContext MR_defaultContext] objectWithID:[[FRUserManager sharedInstance] currentUser].objectID];
    
    
//    UIView* shadowBubble = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
//    shadowBubble.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
//    [shadowBubble addSubview:bubble];
    
//    shadowBubble.layer.cornerRadius = 14;
    
    marker.iconView = bubble;
    [markers addObject:marker];

    
    [events enumerateObjectsUsingBlock:^(FREvent* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj = [[NSManagedObjectContext MR_defaultContext] objectWithID:obj.objectID];
        CLLocationCoordinate2D position = CLLocationCoordinate2DMake([obj.lat floatValue], [obj.lon floatValue]);
        GMSMarker *marker = [GMSMarker markerWithPosition:position];
        marker.title = obj.title;
        UIImageView* view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
        view.layer.cornerRadius = 5;
        
        switch ([obj.gender integerValue]) {
            case FRGenderTypeAll:
            {
                view.image = [UIImage imageNamed:@"purplePoint"];
//                view.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
            } break;
                
            case FRGenderTypeMale:
            {
                view.image = [UIImage imageNamed:@"bluePoint"];
//                view.backgroundColor = [UIColor bs_colorWithHexString:kFriendlyBlueColor];
            }  break;
                
            case FRGenderTypeFemale:
            {
                view.image = [UIImage imageNamed:@"pinkPoint"];
//                view.backgroundColor = [UIColor bs_colorWithHexString:kFriendlyPinkColor];
            } break;
                
            default:
                break;
        }
        
//        UIView* bubble = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 16, 16)];
//        bubble.backgroundColor = [UIColor whiteColor];
//        
//        [bubble addSubview:view];
//        bubble.layer.cornerRadius = 8;
        
        marker.iconView = view;
        marker.userData = obj;
        [markers addObject:marker];
        
    }];
    
    return markers;
}

- (NSArray*)_viewModelFromModel:(NSArray*)eventList
{
    NSMutableArray* viewModels = [NSMutableArray array];
    [eventList enumerateObjectsUsingBlock:^(FREvent* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj = [[NSManagedObjectContext MR_defaultContext] objectWithID:obj.objectID];
        FREventsCellViewModel* viewModel = [FREventsCellViewModel initWithEvent:obj];
        viewModel.delegate = self;
        
        [viewModels addObject:viewModel];
        
        
    }];
    
    return viewModels;
}

- (void)userPhotoSelected:(NSString*)userId
{
    [self.delegate userPhotoSelected:userId];
}

- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event
{
    [self.delegate joinSelectedWithEventId:eventId andModel:event];
}

-(void)selectedShareEvent:(FREvent*)event
{
    [self.delegate shareEvent:event];
}

- (void)partnerPhotoSelected:(NSString*)partnerId
{
    [self.delegate userPhotoSelected:partnerId];
}

- (void)selectedEvent:(FREventsCellViewModel*)viewModel
{
    CGRect cellRect = [self.tableView rectForRowAtIndexPath:[self.tableView indexPathForCell:viewModel.cell]];
    cellRect = CGRectOffset(cellRect, -self.tableView.contentOffset.x, -self.tableView.contentOffset.y);
    
    FREventsCell* cell = (FREventsCell*)viewModel.cell;
    
    cellRect.size = cell.eventImage.frame.size;
    cellRect.origin.y += self.tableView.frame.origin.y + 10;

    
    [self.delegate showEventPreviewWithEvent:[viewModel domainModel] fromFrame:cellRect];
}

- (void)showUserProfile:(UserEntity *)user {
    [self.delegate showUserProfile:user];
}

#pragma mark - FRSearchByCategoryNearbyCellViewModelDelegate

- (void)settingSelected
{
    [self.delegate settingSelected];
}

@end
