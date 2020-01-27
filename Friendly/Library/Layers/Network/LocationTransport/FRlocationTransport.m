//
//  FRLocationTransport.m
//  Friendly
//
//  Created by Jane Doe on 4/8/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLocationTransport.h"
#import "FRPlaceModel.h"
#import "FRNetworkManager.h"
#import "FRPlaceDomainModel.h"


static NSString* const kMyPlacesPath = @"user/places";
static NSString* const kSavePlacePath = @"user/places";
static NSString* const kGetPlace = @"https://maps.googleapis.com/maps/api/place/details/json?placeid=";
static NSString* const kMyLocationPlace = @"user/location_text";

@implementation FRLocationTransport

+ (void)getMyPlacesSuccess:(void(^)(FRPlacesModel* models))success
                   failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kMyPlacesPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRPlacesModel* models = [[FRPlacesModel alloc] initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(models);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)savePlace:(FRPlaceDomainModel*)place
          success:(void(^)(FRPlaceModel* model))success
          failure:(void(^)())failure
{
    [NetworkManager POST_Path:kSavePlacePath parameters:[place domainModelDictionary] success:^(id response) {
        NSError* error;
        FRPlaceModel* place = [[FRPlaceModel alloc] initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(place);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
    
}

+ (void)getPlaceIconWithPlaceId:(NSString*)placeId
                   success:(void(^)(NSString* icon))success
                   failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:[NSString stringWithFormat:@"%@%@&key=AIzaSyBkU4wHvmdaVZlYx6qN9Wi66ijHFpdI_lk", kGetPlace, placeId] parameters:@{} success:^(id response) {
        
        NSError* error;
        FRPlaceIconResultModel* result = [[FRPlaceIconResultModel alloc] initWithDictionary:response error:&error];
        NSString* icon = [result.result objectForKey:@"icon"];
        if (error)
        {
            failure(error);
            return ;
        }
        if (icon == nil) {
            icon = @"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png";
        }
        if (success)
            success(icon);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getMyLocationNameSuccess:(void(^)(NSString* place))success
                                  failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kMyLocationPlace parameters:@{} success:^(id response) {
        
        NSError* error;
        
        NSString* place = [[NSString alloc] initWithString:[response objectForKey:@"address"]];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(place);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

@end
