//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterDataSource.h"
#import "BSMemoryStorage.h"
#import "FREventFilterSortByCellViewModel.h"
#import "FREventFilterWhatYouSeeCellViewModel.h"
#import "FRCreateEventAgeCellViewModel.h"
#import "FREventFilterDistanceCellViewModel.h"
#import "FREventFilterAgeRangeCellViewModel.h"
#import "FREventFilterViewConstatns.h"
#import "FRUserModel.h"
#import "FREventFilterDomainModel.h"

@implementation FREventFilterDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorageWithFilter:(Filter*)model
{
    FREventFilterSortByCellViewModel* sortByModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    if (!sortByModel) {
        
       sortByModel = [FREventFilterSortByCellViewModel new];
        [self.storage addItem:sortByModel];
    }
    sortByModel.segmentSelectedIndex = [model.sortByDate integerValue];
    [self.storage reloadItem:sortByModel];
    
    FREventFilterWhatYouSeeCellViewModel* whatYouSeeModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];

    if (!whatYouSeeModel) {
        whatYouSeeModel = [FREventFilterWhatYouSeeCellViewModel new];
        [self.storage addItem:whatYouSeeModel];
    }
    
    FRCreateEventAgeCellViewModel* dateModel  = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    if (!dateModel){
        
        dateModel = [FRCreateEventAgeCellViewModel new];
        [self.storage addItem:dateModel];
    }
    dateModel.title = FRLocalizedString(@"Date", nil);
    dateModel.cellType = FRAgeCellTypeLabel;
    dateModel.dateType = [model.date integerValue];
    switch ([model.date integerValue]) {
        case 0:
            dateModel.contentTitle = @"Anytime";
            break;
        case 1:
            dateModel.contentTitle = @"This weekend";
            break;
        case 2:
            dateModel.contentTitle = @"This week";
            break;

        default:
            break;
    }
    [self.storage reloadItem:dateModel];
    
    
    FRCreateEventAgeCellViewModel* locationModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    if (!locationModel){
        locationModel = [FRCreateEventAgeCellViewModel new];
        [self.storage addItem:locationModel];
    }
    
    locationModel.title = FRLocalizedString(@"Location", nil);
    locationModel.cellType = FRAgeCellTypeLabel;
    if (model.placeName == nil) {
        locationModel.contentTitle = @"Current location";
    }
    else
    {
        locationModel.contentTitle = model.placeName;
        locationModel.place_name = model.placeName;
        locationModel.lon = [NSString stringWithFormat:@"%@", model.lot];
        locationModel.lat = [NSString stringWithFormat:@"%@", model.lan];
    }
    [self.storage reloadItem:locationModel];
    
    
    
    FREventFilterDistanceCellViewModel* distanceModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    if (!distanceModel) {
        
        distanceModel = [FREventFilterDistanceCellViewModel new];
        [self.storage addItem:distanceModel];
    }
    distanceModel.radius = [model.distance integerValue] ? [model.distance integerValue] : 1;
    [self.storage reloadItem:distanceModel];
    
    
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
    if(!genderModel) {
        
       genderModel = [FRCreateEventAgeCellViewModel new];
        [self.storage addItem:genderModel];
    }
    genderModel.cellType = FRAgeCellTypeImage;
    genderModel.gender = [model.gender integerValue];
    genderModel.type = FRCreateEventCellTypeGender;
    genderModel.title = FRLocalizedString(@"Gender", nil);
    [self.storage reloadItem:genderModel];
    
    
    FREventFilterAgeRangeCellViewModel* ageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    if (!ageModel) {
        
       ageModel = [FREventFilterAgeRangeCellViewModel new];
        [self.storage addItem:ageModel];
    }
    ageModel.minAge = [model.ageMin integerValue] < 18 ? 18 : [model.ageMin integerValue];//min  == 18
    ageModel.maxAge = [model.ageMax integerValue] < 18 ? 18 : [model.ageMax integerValue];
    [self.storage reloadItem:ageModel];
}

- (void)updateGender:(FRGenderType)type
{
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellGender inSection:0]];
    genderModel.gender = type;
    [self.storage reloadItem:genderModel];
}

- (void)updateLocationWithLat:(NSString*)lat lon:(NSString*)lon name:(NSString*)name
{
    FRCreateEventAgeCellViewModel* locationModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellLocation inSection:0]];
    locationModel.contentTitle = name;
    locationModel.lat = lat;
    locationModel.lon = lon;
    locationModel.place_name = name;
    [self.storage reloadItem:locationModel];
}

- (void)updateDate:(FRDateFilterType)type andText:(NSString*)text
{
    FRCreateEventAgeCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellDate inSection:0]];
    dateModel.contentTitle = text;
    dateModel.dateType = type;
    [self.storage reloadItem:dateModel];
}

- (FRDateFilterType)dateType
{
    FRCreateEventAgeCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellDate inSection:0]];
    return dateModel.dateType;
}

- (FRGenderType)genderType
{
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellGender inSection:0]];
    return genderModel.gender;
}

- (FREventFilterDomainModel*)filterModel
{
    FREventFilterDomainModel* model = [FREventFilterDomainModel new];
    
    FREventFilterSortByCellViewModel* sortByModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellSortBy inSection:0]];
    model.sort_by_date = sortByModel.segmentSelectedIndex;
    
     FRCreateEventAgeCellViewModel* dateModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellDate inSection:0]];
    model.date = dateModel.dateType;
    
    FRCreateEventAgeCellViewModel* genderModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellGender inSection:0]];
    model.gender = genderModel.gender;
    
    FRCreateEventAgeCellViewModel* locationModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellLocation inSection:0]];
    model.lat = locationModel.lat;
    model.lon = locationModel.lon;
    model.place_name = locationModel.place_name;
    
    FREventFilterAgeRangeCellViewModel* ageModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellAgeRange inSection:0]];
    model.age_max = ageModel.maxAge;
    model.age_min = ageModel.minAge;
    
    FREventFilterDistanceCellViewModel* distanceModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FREventFilterCellDistance inSection:0]];
    
    model.distance = distanceModel.radius;
    
    return model;
}

#pragma mark - Private



@end
