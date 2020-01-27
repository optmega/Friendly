//
//  FRLocationManager.h
//  Friendly
//
//  Created by Sergey Borichev on 01.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class GMSAutocompletePrediction;

@interface FRLocationManager : NSObject

+ (instancetype)sharedInstance;

+ (void)placeAutocomplete:(NSString*)text
                   places:(void(^)(NSArray<GMSAutocompletePrediction*>* places))places;
+ (void)placeNearby:(void(^)(NSArray* places))places;

- (CLLocationCoordinate2D)location;
- (BOOL)verifiLocationManager;
- (void)startUpdateLocationManager;
- (void)stopUpdateLocationManager;

@end
