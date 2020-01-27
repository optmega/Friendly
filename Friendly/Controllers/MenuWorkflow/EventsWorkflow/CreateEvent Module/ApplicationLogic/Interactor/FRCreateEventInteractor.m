//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInteractor.h"
#import "FREventTransport.h"
#import "FRCreateEventLocationDomainModel.h"
#import "UIImageHelper.h"
#import "FRUploadImage.h"
#import "FREventDomainModel.h"
#import "FRRequestTransport.h"
#import "FREventModel.h"
#import "FRGroupRoom.h"
#import "FRDataBaseManager.h"
#import "CreateEvent.h"


@import GoogleMaps;
@import GooglePlaces;

@interface FRCreateEventInteractor ()

@property (nonatomic, strong) FREvent* event;

@end

@implementation FRCreateEventInteractor

- (void)loadDataWithEvent:(FREvent *)event
{
    if (event)
    {
        self.event = event;
        [self.output dataLoadedWithEvent:event];
        
        [FREventTransport checkFeaturedEvents:^(FREventFeatureModel* model) {
            [self.output updateInviteSection:model];
        } failure:^(NSError *error) {
            
        }];
        
        return;
    }
    
    [self.output dataLoaded];
    
    [FREventTransport checkFeaturedEvents:^(FREventFeatureModel* model) {
        [self.output updateInviteSection:model];
    } failure:^(NSError *error) {
        
    }];

}

- (void)deleteEvent
{
    
    [FREventTransport deleteEventWithId:self.event.eventId success:^{
        [self.event MR_deleteEntity];
        [self.output createdEvent:nil];
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRCreateEventHudTypeError title:@"Error" message:error.localizedDescription];
    }];
}

- (void)createEvent:(FREventDomainModel*)event usersToInvite:(NSArray*)users
{
    if (!event)
    {
        return;
    }
    
    NSString* stringFromArray = [NSString new];
    for (int i = 0; i<users.count; i++)
    {
        stringFromArray = [stringFromArray stringByAppendingString:[NSString stringWithFormat:@"%@,", users[i]]];
    }
    if (stringFromArray.length > 0)
    event.requests = [stringFromArray substringToIndex:[stringFromArray length]-1];
    
    NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
    
    if (self.event)  //update mode
    {
        CreateEvent* newEvent = [CreateEvent createFromDomain:event inContext:context];
        newEvent.eventId = self.event.eventId;
        newEvent.event_start = event.event_start;
        newEvent.isUpdate = @(true);
    } else {
        
        [CreateEvent createFromDomain:event inContext:context];
    }
    
    [context MR_saveToPersistentStoreAndWait];
    
    
    if (self.event) {
        [FRDataBaseManager updateEvent];
        
        [self.output createdEvent:nil];
        return ;
    } else {
        
        [self.output createdEvent:nil];
        
        [FRDataBaseManager uploadEvent];
    }
    
}

- (void)lookPlaceWithId:(NSString *)placeId
{
    
    [self.output showHudWithType:FRCreateEventHudTypeShowHud title:nil message:nil];
    
    FRCreateEventLocationDomainModel* locationModel = [FRCreateEventLocationDomainModel new];
    GMSPlacesClient* placeClient = [GMSPlacesClient sharedClient];
    
    [placeClient lookUpPlaceID:placeId callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
       
        locationModel.coordinate = result.coordinate;
        locationModel.placeName = result.name;
//        [placeClient lookUpPhotosForPlaceID:placeId callback:^(GMSPlacePhotoMetadataList * _Nullable photos, NSError * _Nullable error) {
//            
//            GMSPlacePhotoMetadata* metadata = photos.results.firstObject;
//            [placeClient loadPlacePhoto:metadata callback:^(UIImage * _Nullable photo, NSError * _Nullable error) {
//                
//                if (error) {
//                    [self.output showHudWithType:FRCreateEventHudTypeError title:@"Error" message:@"No photo."];
//                }
//                else
//                {
//                    [self.output showHudWithType:FRCreateEventHudTypeHideHud title:nil message:nil];
//                    locationModel.locationPhoto = [UIImageHelper addFilter:photo];
//                }
                [self.output showHudWithType:FRCreateEventHudTypeHideHud title:nil message:nil];
                [self.output updateLocationWithDomainModel:locationModel];
//            }];
        
            
//        }];
    }];
}

@end
