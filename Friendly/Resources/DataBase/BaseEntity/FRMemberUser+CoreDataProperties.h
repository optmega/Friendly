//
//  FRMemberUser+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRMemberUser.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRMemberUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *photo;
@property (nullable, nonatomic, retain) NSNumber *friendFacebook;

@end

NS_ASSUME_NONNULL_END
