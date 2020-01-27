//
//  Setting+CoreDataProperties.h
//  Friendly
//
//  Created by Sergey on 07.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Setting.h"

NS_ASSUME_NONNULL_BEGIN

@interface Setting (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *groupMessagesNotification;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSNumber *eventInvites;
@property (nullable, nonatomic, retain) NSNumber *friendRequests;
@property (nullable, nonatomic, retain) NSNumber *eventRequests;
@property (nullable, nonatomic, retain) NSNumber *privateAccount;
@property (nullable, nonatomic, retain) CurrentUser *user;

@end

NS_ASSUME_NONNULL_END
