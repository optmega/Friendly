//
//  CurrentUser+CoreDataProperties.h
//  Friendly
//
//  Created by Sergey on 07.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CurrentUser.h"
#import "FREvent.h"
#import "Setting.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSSet<UserEntity *> *friends;
@property (nullable, nonatomic, retain) NSSet<FREvent *> *hostingEvents;
@property (nullable, nonatomic, retain) NSSet<FREvent *> *joingEvents;
@property (nullable, nonatomic, retain) Setting *setting;
@property (nullable, nonatomic, retain) NSNumber* allFriendsCount;
@property (nullable, nonatomic, retain) NSNumber* availableToMeetUsersCount;

@end

@interface CurrentUser (CoreDataGeneratedAccessors)

- (void)addFriendsObject:(UserEntity *)value;
- (void)removeFriendsObject:(UserEntity *)value;
- (void)addFriends:(NSSet<UserEntity *> *)values;
- (void)removeFriends:(NSSet<UserEntity *> *)values;

- (void)addHostingEventsObject:(FREvent *)value;
- (void)removeHostingEventsObject:(FREvent *)value;
- (void)addHostingEvents:(NSSet<FREvent *> *)values;
- (void)removeHostingEvents:(NSSet<FREvent *> *)values;

- (void)addJoingEventsObject:(FREvent *)value;
- (void)removeJoingEventsObject:(FREvent *)value;
- (void)addJoingEvents:(NSSet<FREvent *> *)values;
- (void)removeJoingEvents:(NSSet<FREvent *> *)values;

@end

NS_ASSUME_NONNULL_END
