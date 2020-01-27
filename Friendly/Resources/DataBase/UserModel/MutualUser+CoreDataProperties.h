//
//  MutualUser+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "MutualUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface MutualUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSString *thumbnail;
@property (nullable, nonatomic, retain) UserEntity *user;

@end

NS_ASSUME_NONNULL_END
