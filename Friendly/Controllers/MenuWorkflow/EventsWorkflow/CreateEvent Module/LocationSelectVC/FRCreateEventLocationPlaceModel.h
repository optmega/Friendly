//
//  FRCreateEventLocationPlaceModel.h
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRLocationManager.h"
#import "FRPlaceModel.h"

@import GoogleMaps;
@import GooglePlaces;

@interface FRCreateEventLocationPlaceModel : NSObject

+ (instancetype) initWithNearbyModel:(GMSPlace*)model;
+ (instancetype) initWithAutocompleteModel:(GMSAutocompletePrediction*)model;
+ (instancetype) initWithRecentlySearchedModel:(FRPlaceModel*)model;

@property (nonatomic, strong) NSString* placeName;
@property (nonatomic, strong) NSString* placeAddress;
@property (nonatomic, strong) NSString* placeID;
@property (nonatomic, strong) NSString* days_from_last_search;

@end
 