//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsInteractor.h"
#import "FREventTransport.h"
#import "FREventModel.h"
#import "FRLocationManager.h"
#import "FRWebSoketManager.h"
#import "FRWebSocketTransport.h"
#import "FRDataBaseManager.h"

@interface FREventsInteractor ()

@property (nonatomic, assign) FRSegmentType eventsType;

@end

@implementation FREventsInteractor

- (void)loadData
{
    [self.output dataLoaded];
    
    FRWebSoketManager* socketManager = [FRWebSoketManager shared];
    socketManager.delegate = [FRDataBaseManager shared];
    [socketManager connect];
    
//    BSDispatchBlockAfter(4,^{
//    
//        [FRWebSocketTransport sendMessage:@"Hello" toUserId:@"118"];
//    });
}

- (void)updateEvents
{
    [self updateEventsWithType:self.eventsType];
}

- (void)updateEventsWithType:(FRSegmentType)type
{
    switch (type) {
        case FRSegmentTypeFeatured:
        {
            [self _updateFearuredEvents];
        } break;
        
        case FRSegmentTypeNearby:
        {
            [self _updateNearbyEvents];
        } break;
        
        case FRSegmentTypeFriends:
        {
            [self _updateFriendsEvents];
        } break;
    }
    
    self.eventsType = type;
}

- (void)_updateFearuredEvents
{
//    [self.output showHudWithType:FREventsHudTypeShowHud title:nil message:nil];
    
    if (self.eventsType != FRSegmentTypeFeatured)
    {
        [self.output showHudWithType:FREventsHudTypeShowHud title:nil message:nil];
    }
    
    
    [FREventTransport getFeaturedListWithPage:1 success:^(FREventModels *models) {
        
        [self.output showHudWithType:FREventsHudTypeHideHud title:nil message:nil];
        [self.output featuredEventsLoaded:models];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FREventsHudTypeError title:FRLocalizedString(@"Error", nil) message:error.localizedDescription];
    }];
}

- (void)_updateNearbyEvents
{
    CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
    
    if (self.eventsType != FRSegmentTypeNearby)
    {
        [self.output showHudWithType:FREventsHudTypeShowHud title:nil message:nil];
    }
    

    
//    [FREventTransport getNearbyListLat:[NSString stringWithFormat:@"%f", location.latitude]
//                                   lon:[NSString stringWithFormat:@"%f", location.longitude]
//                                  page:1
//                               success:^(FREventModels *models) {
//                                   
//                                   [self.output showHudWithType:FREventsHudTypeHideHud title:nil message:nil];
//                                   [self.output featuredEventsLoaded:models];
    
//    } failure:^(NSError *error) {
//        [self.output showHudWithType:FREventsHudTypeError title:FRLocalizedString(@"Error", nil) message:error.localizedDescription];
//    }];
}


- (void)_updateFriendsEvents
{
//    if (self.eventsType != FRSegmentTypeFriends)
//    {
//        [self.output showHudWithType:FREventsHudTypeShowHud title:nil message:nil];
//    }
//    
//    [FREventTransport getFriendWithFilter:NO page:1 list:^(FRFriendEventsModel *models) {
//        [self.output showHudWithType:FREventsHudTypeHideHud title:nil message:nil];
//        [self.output friendEventsLoaded:models];
//        
//    } failure:^(NSError *error) {
//        [self.output showHudWithType:FREventsHudTypeError title:FRLocalizedString(@"Error", nil) message:error.localizedDescription];
//    }];
}

@end
