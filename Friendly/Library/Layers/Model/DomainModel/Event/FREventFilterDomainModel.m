//
//  FREventFilterDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterDomainModel.h"

static const struct
{
    __unsafe_unretained NSString *distance;
    __unsafe_unretained NSString *age_min;
    __unsafe_unretained NSString *age_max;
    __unsafe_unretained NSString *gender;
    __unsafe_unretained NSString *date;
    __unsafe_unretained NSString *lon;
    __unsafe_unretained NSString *lat;
    __unsafe_unretained NSString *place_name;
    __unsafe_unretained NSString *sort_by_date;

} FRFilterParametr =
{
    .distance     = @"distance",
    .age_min      = @"age_min",
    .age_max      = @"age_max",
    .gender       = @"gender",
    .date         = @"date",
    .lon          = @"lon",
    .lat          = @"lat",
    .place_name   = @"place_name",
    .sort_by_date = @"sort_by_date",
};



@implementation FREventFilterDomainModel

- (NSDictionary*)domainModelDictionary
{
    return @{  FRFilterParametr.distance : @(self.distance),
                FRFilterParametr.age_max : @(self.age_max),
                FRFilterParametr.age_min : @(self.age_min),
                 FRFilterParametr.gender : @(self.gender),
                   FRFilterParametr.date : @(self.date),
                    FRFilterParametr.lat : [NSObject bs_safeString:self.lat],
                    FRFilterParametr.lon : [NSObject bs_safeString:self.lon],
             FRFilterParametr.place_name : [NSObject bs_safeString:self.place_name],
           FRFilterParametr.sort_by_date : @(self.sort_by_date)};
}

@end
