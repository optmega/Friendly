//
//  Filter+Create.m
//  Friendly
//
//  Created by Dmitry on 24.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "Filter+Create.h"
#import "FRUserModel.h"

@implementation Filter (Create)

+ (instancetype)initFilterWith:(FRFilterModel*)filterModel inContext:(NSManagedObjectContext*)context{
   
    Filter* filter = [Filter MR_createEntityInContext:context];
    
    filter.distance = @([filterModel.distance integerValue]);
    filter.ageMin = @([filterModel.age_min integerValue]);
    filter.ageMax = @([filterModel.age_max integerValue]);
    filter.gender = filterModel.gender;
    filter.lan = @([filterModel.lat doubleValue]);
    filter.lot = @([filterModel.lon doubleValue]);
    filter.placeName = filterModel.place_name;
    filter.sortByDate = @(filterModel.sort_by_date.integerValue);
    filter.date = @(filterModel.date.integerValue);
    return filter;
}
@end
