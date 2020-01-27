//
//  FREventFilterDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseDomainModel.h"

@interface FREventFilterDomainModel : FRBaseDomainModel

@property (nonatomic, assign) NSInteger distance;
@property (nonatomic, assign) NSInteger age_min;
@property (nonatomic, assign) NSInteger age_max;
@property (nonatomic, assign) NSInteger gender;
@property (nonatomic, assign) NSInteger date;
@property (nonatomic, assign) NSString* lat;
@property (nonatomic, assign) NSString* lon;
@property (nonatomic, assign) NSString* place_name;
@property (nonatomic, assign) NSInteger sort_by_date;

@end
