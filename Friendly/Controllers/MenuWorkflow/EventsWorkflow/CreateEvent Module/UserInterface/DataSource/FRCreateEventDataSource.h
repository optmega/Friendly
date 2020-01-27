//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventDomainModel.h"
@class BSMemoryStorage, FREventFeatureModel, FRCreateEventLocationPlaceModel, FRPictureModel, FRCreateEventLocationDomainModel, FREventModel;


@protocol FRCreateEventDataSourceDelegate <NSObject>

- (void)backSelected;
- (void)showPhotoPicker;
- (void)emptyEventField:(NSString*)string;
- (void)updateEventSelected;
- (void)deleteEvent;
- (void)inviteUsers;
- (void)showVerifyAlert:(NSString*)alert;
- (void)createEventSelected;

@end

@interface FRCreateEventDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRCreateEventDataSourceDelegate> delegate;

- (void)setupStorage;
- (void)setupStorageWithEvent:(FREvent*)event;
- (FREventDomainModel*)event;
- (void)updateCategory:(NSString*)category andId:(NSString*)id;
- (void)updateAgesMin:(NSInteger)min max:(NSInteger)max;
- (void)updateGender:(FRGenderType)genderType;
- (void)updateOpenSlots:(NSInteger)openSlots;
- (void)updateTime:(NSDate*)time;
- (void)updateLocation:(FRCreateEventLocationDomainModel*)location;
- (void)updateDate:(NSDate*)date;
- (void)updateInviteUsers:(NSArray*)friends;
- (void)updateEventImage:(UIImage*)eventImage;
- (void)verifyFields;
- (void)updateEventImage:(UIImage*)eventImage with:(FRPictureModel*)model;
- (void)updateCoHost:(NSString*)partnerId :(NSString*)partnerName;
- (NSArray*)ages;
- (FRGenderType)gender;
- (NSInteger)openSlots;
- (NSDate*)evendDate;
- (NSDate*)eventTime;
- (void)updateFeature:(FREventFeatureModel*)model;

@end
