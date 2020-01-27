//
//  FRCreateEventLocationPlaceModel.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventLocationPlaceModel.h"
#import "FRPlaceModel.h"

@import GoogleMaps;

@interface FRCreateEventLocationPlaceModel()

@property (nonatomic, strong) GMSPlace* modelPlace;
@property (nonatomic, strong) GMSAutocompletePrediction* modelPredication;
@property (nonatomic, strong) FRPlaceModel* modelRecentlyPlace;

@end

@implementation FRCreateEventLocationPlaceModel

+ (instancetype) initWithNearbyModel:(GMSPlace*)model
{
    FRCreateEventLocationPlaceModel* viewModel = [FRCreateEventLocationPlaceModel new];
    viewModel.modelPlace = model;

    return viewModel;
}

+ (instancetype) initWithAutocompleteModel:(GMSAutocompletePrediction*)model
{
    FRCreateEventLocationPlaceModel* viewModel = [FRCreateEventLocationPlaceModel new];
    viewModel.modelPredication = model;

    return viewModel;
}

+ (instancetype) initWithRecentlySearchedModel:(FRPlaceModel*)model;
{
    FRCreateEventLocationPlaceModel* viewModel = [FRCreateEventLocationPlaceModel new];
    viewModel.modelRecentlyPlace = model;
    
    return viewModel;
}

-(NSString*) placeName
{
    if (self.modelPlace)
    {
        return self.modelPlace.name;
    }
    if (self.modelPredication)
    {
    return [[self.modelPredication.attributedPrimaryText mutableCopy] string];
    }
    return self.modelRecentlyPlace.name;
}
-(NSString*) placeAddress
{
    if (self.modelPlace)
    {
        return self.modelPlace.formattedAddress;
    }
    if (self.modelPredication)
    {
    return [[self.modelPredication.attributedFullText mutableCopy] string];
    }
    return self.modelRecentlyPlace.address;

}
-(NSString*) placeID
{
    if (self.modelPlace)
    {
        return self.modelPlace.placeID;
    }
    if (self.modelPredication)
    {
    return self.modelPredication.placeID;
    }
    return self.modelRecentlyPlace.google_place_id;
}

-(NSString*) days_from_last_search
{
    if (self.modelRecentlyPlace)
    {
       return self.modelRecentlyPlace.days_from_last_search;
    }
    else
        return @"";
}

@end
