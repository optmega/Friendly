//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterPresenter.h"
#import "FREventFilterDataSource.h"
#import "BSHudHelper.h"
#import "FRCreateEventLocationPlaceModel.h"


@import GooglePlaces;

@interface FREventFilterPresenter () <FREventFilterDataSourceDelegate>

@property (nonatomic, strong) FREventFilterDataSource* tableDataSource;

@end

@implementation FREventFilterPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FREventFilterDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FREventFilterViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoaded:(Filter*)model
{
    [self.tableDataSource setupStorageWithFilter:model];
}

- (void)showHudWithType:(FREventFilterHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)close
{
    [self.wireframe dismissEventFilterController];
}

- (void)selectedGender:(FRGenderType)gender
{
    [self.tableDataSource updateGender:gender];
}

- (void)selectedDate:(FRDateFilterType)type andText:(NSString*)text
{
    [self.tableDataSource updateDate:type andText:text];
}

-(void) selectedLocation:(FRCreateEventLocationPlaceModel*)returnModel
{
    GMSPlacesClient* placeClient = [GMSPlacesClient sharedClient];
    
    [placeClient lookUpPlaceID:returnModel.placeID callback:^(GMSPlace * _Nullable result, NSError * _Nullable error) {
        NSString* lat = [NSString stringWithFormat:@"%f",result.coordinate.latitude];
         NSString* lon = [NSString stringWithFormat:@"%f",result.coordinate.longitude];
        NSString* name = [NSString stringWithFormat:@"%@", result.name];
        [self.tableDataSource updateLocationWithLat:lat lon:lon name:name];
    }];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissEventFilterController];
}

- (void)doneSelected
{
    [self.interactor updateFilter:[self.tableDataSource filterModel]];
}

- (void)dateSelected
{
    [self.wireframe presentDateVCWithDateType];
}

- (void)genderSelected
{
    [self.wireframe presentGenderVCWithGenderType:[self.tableDataSource genderType]];
}

- (void)locationSelected
{
    [self.wireframe presentLocationVC];
}

@end
