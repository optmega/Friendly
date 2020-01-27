//
//  Invite+CoreDataProperties.h
//  Friendly
//
//  Created by Sergey on 13.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Invite.h"

NS_ASSUME_NONNULL_BEGIN

@interface Invite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *referralId;

@end

NS_ASSUME_NONNULL_END
