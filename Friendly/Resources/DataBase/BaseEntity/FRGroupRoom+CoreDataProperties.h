//
//  FRGroupRoom+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRGroupRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRGroupRoom (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *eventDate;
@property (nullable, nonatomic, retain) NSString *eventName;
@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) NSString *lastUserPhoto;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *members;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *messages;
@property (nullable, nonatomic, retain) NSDate *joined_at;
@property (nullable, nonatomic, retain) FREvent* event;

@end

@interface FRGroupRoom (CoreDataGeneratedAccessors)

- (void)addMembersObject:(NSManagedObject *)value;
- (void)removeMembersObject:(NSManagedObject *)value;
- (void)addMembers:(NSSet<NSManagedObject *> *)values;
- (void)removeMembers:(NSSet<NSManagedObject *> *)values;

- (void)addMessagesObject:(NSManagedObject *)value;
- (void)removeMessagesObject:(NSManagedObject *)value;
- (void)addMessages:(NSSet<NSManagedObject *> *)values;
- (void)removeMessages:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
