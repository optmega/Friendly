//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventDomainModel, FRCreateEventLocationDomainModel, FREventModel;

typedef NS_ENUM(NSInteger, FRCreateEventHudType) {
    FRCreateEventHudTypeError,
    FRCreateEventHudTypeShowHud,
    FRCreateEventHudTypeHideHud,
};

@protocol FRCreateEventInteractorInput <NSObject>

- (void)loadDataWithEvent:(FREventModel*)event;
- (void)createEvent:(FREventDomainModel*)event usersToInvite:(NSArray*)users;
- (void)lookPlaceWithId:(NSString*)placeId;
- (void)deleteEvent;
@end


@protocol FRCreateEventInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)dataLoadedWithEvent:(FREvent*)model;
- (void)showHudWithType:(FRCreateEventHudType)type title:(NSString*)title message:(NSString*)message;
- (void)createdEvent:(FREvent*)event;

- (void)updateLocationWithDomainModel:(FRCreateEventLocationDomainModel*)domainModel;
- (void)updateInviteSection:(FREventFeatureModel*)model;

@end