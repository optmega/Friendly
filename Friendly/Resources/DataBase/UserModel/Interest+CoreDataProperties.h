//
//  Interest+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Interest.h"

NS_ASSUME_NONNULL_BEGIN

@interface Interest (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *interestId;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *isMutual;
@property (nullable, nonatomic, retain) UserEntity *user;

@end

NS_ASSUME_NONNULL_END
