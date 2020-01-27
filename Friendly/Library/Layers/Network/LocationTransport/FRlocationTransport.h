//
//  FRLocationTransport.h
//  Friendly
//
//  Created by Jane Doe on 4/8/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRPlaceModel, FRPlaceDomainModel, FRPlacesModel;

@interface FRLocationTransport : NSObject

+ (void)getMyPlacesSuccess:(void(^)(FRPlacesModel* models))success
                   failure:(void(^)(NSError* error))failure;

+ (void)savePlace:(FRPlaceDomainModel*)place
          success:(void(^)(FRPlaceModel* model))success
          failure:(void(^)())failure;

+ (void)getPlaceIconWithPlaceId:(NSString*)placeId
                        success:(void(^)(NSString* icon))success
                        failure:(void(^)(NSError* error))failure;

+ (void)getMyLocationNameSuccess:(void(^)(NSString* place))success
                         failure:(void(^)(NSError* error))failure;


@end

