//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsDataSource.h"
#import "BSMemoryStorage.h"
#import "FREventListCellViewModel.h"
#import "FREventsCellViewModel.h"
#import "FREventModel.h"
#import "FRAdvertisementCellViewModel.h"
#import "FRUserManager.h"

@interface FREventsDataSource ()<FREventsCellViewModelDelegate, FREventListCellViewModelDelegate, FRAdvertisementCellViewModelDelegate>


@end

@implementation FREventsDataSource

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
    
}

- (void)featuredModelsUpdate:(FREventModels*)eventsModel
{
    if (!eventsModel.events.count)
    {
        [self.storage removeAllItems];
        return;
    }
    
    FREventListCellViewModel* model = [FREventListCellViewModel new];
    model.delegate = self;
    model.list = eventsModel.top_events;
    
    NSMutableArray* array = [NSMutableArray arrayWithObject:model];
   
    if ([FRUserManager sharedInstance].canShowAdvertisement)
    {
        FRAdvertisementCellViewModel* advertisement = [FRAdvertisementCellViewModel new];
        advertisement.isShowAdvertisement = YES;
        [array addObject:advertisement];
    }
    
    [array addObjectsFromArray:[self _veiwModelFromView:eventsModel.events]];
    [self.storage removeAndAddNewItems:array];
}

- (void)friendEventsUpdate:(FRFriendEventsModel*)eventsModel
{
    
    if (!eventsModel.events.count)
    {
        [self.storage removeAllItems];
        return;
    }
    NSMutableArray* array = [NSMutableArray array];
    
    [array addObjectsFromArray:[self _veiwModelFromView:eventsModel.events]];
    [self.storage removeAndAddNewItems:array];

}

#pragma mark - Private

- (NSArray*)_veiwModelFromView:(NSArray*)models
{
//    NSMutableArray* viewModels = [NSMutableArray array];
//    [models enumerateObjectsUsingBlock:^(FREventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        FREventsCellViewModel* viewModel = [FREventsCellViewModel initWithModel:obj];
//        viewModel.delegate = self;
//        [viewModels addObject:viewModel];
//    }];
    
    return nil;
}


#pragma mark - FREventsCellViewModelDelegate

- (void)partnerPhotoSelected:(NSString *)partnerId
{
    [self.delegate showUserProfile:partnerId];
}

- (void)userPhotoSelected:(NSString*)userId
{
    [self.delegate showUserProfile:userId];
}

- (void)selectedShareEvent:(FREventModel*)eventId
{
    [self.delegate shareEvent:eventId];
}

#pragma mark - FRAdvertisementCellViewModelDelegate

- (void)advertisementReloadData:(FRAdvertisementCellViewModel*)item
{
    [self.storage reloadItem:item];
}


//- (void)selectedShareEvent:(FREventModel*)event
//{
//    [self.delegate shareEvent:event];
//}


#pragma mark - FREventListCellViewModelDelegate

- (void)pressUserPhoto:(NSString*)userId
{
    [self.delegate showUserProfile:userId];
}

- (void)selectedJointEventId:(NSString*)eventId andModel:(FREventModel*)event
{
    [self.delegate joinEventViewSelectedWithEventId:eventId andModel:event];
}


- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREventModel*)event
{
    [self.delegate joinEventViewSelectedWithEventId:eventId andModel:event];
}

- (void)dealloc
{
    self.storage = nil;
}

@end
