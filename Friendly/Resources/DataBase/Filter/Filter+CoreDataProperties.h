//
//  Filter+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 24.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Filter.h"

NS_ASSUME_NONNULL_BEGIN

@interface Filter (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *distance;
@property (nullable, nonatomic, retain) NSNumber *ageMin;
@property (nullable, nonatomic, retain) NSNumber *ageMax;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSNumber *date;
@property (nullable, nonatomic, retain) NSNumber *lan;
@property (nullable, nonatomic, retain) NSNumber *lot;
@property (nullable, nonatomic, retain) NSString *placeName;
@property (nullable, nonatomic, retain) NSNumber *sortByDate;

@end

NS_ASSUME_NONNULL_END

