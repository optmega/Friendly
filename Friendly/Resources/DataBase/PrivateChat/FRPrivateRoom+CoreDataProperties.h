//
//  FRPrivateRoom+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRPrivateRoom.h"
#import "UserEntity.h"


NS_ASSUME_NONNULL_BEGIN

@interface FRPrivateRoom (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *opponentBirthday;
@property (nullable, nonatomic, retain) NSString *opponentName;
@property (nullable, nonatomic, retain) NSString *roomId;
@property (nullable, nonatomic, retain) NSString *roomImage;
@property (nullable, nonatomic, retain) NSSet<FRPrivateMessage *> *messages;
@property (nullable, nonatomic, retain) NSString *userId;

@property (nullable, nonatomic, retain) UserEntity* opponent;

@end

@interface FRPrivateRoom (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(FRPrivateMessage *)value;
- (void)removeMessagesObject:(FRPrivateMessage *)value;
- (void)addMessages:(NSSet<FRPrivateMessage *> *)values;
- (void)removeMessages:(NSSet<FRPrivateMessage *> *)values;

@end

NS_ASSUME_NONNULL_END
