//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryInteractor.h"
#import "FREventTransport.h"
#import "FREventModel.h"
#import "FRLocationManager.h"

@interface FRSearchEventByCategoryInteractor ()

@property (nonatomic, assign) BOOL isFirstSearch;

@end

@implementation FRSearchEventByCategoryInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.isFirstSearch = YES;
    }
    return self;
}

- (void)loadData
{
    [self.output dataLoaded];
    
//    CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
//    
//    [FREventTransport getNearbyListLat:[NSString stringWithFormat:@"%f",location.latitude]  lon:[NSString stringWithFormat:@"%f",location.longitude] success:^(FREventModels *models) {
//        [self.output loadedEvents:models.events];
//    } failure:^(NSError *error) {
//        
//    }];
    
}

- (void)loadEventWithString:(NSString*)string
{
    ///
    [FREventTransport searchEventsByTitle:string success:^(FREventSearchEntityModels *models) {
        NSMutableArray* array = [NSMutableArray array];
//        [array addObjectsFromArray:models.related_category];
        
//        if (!self.isFirstSearch)
//        {
        NSMutableArray* usersArray = [NSMutableArray array];
        [usersArray addObjectsFromArray:models.discover_people];
            [array addObjectsFromArray:models.events];
//        }
//        self.isFirstSearch = NO;
//
        
        [self.output loadedEvents:array users:usersArray];
    } failure:^(NSError *error) {
        
    }];
}
@end
