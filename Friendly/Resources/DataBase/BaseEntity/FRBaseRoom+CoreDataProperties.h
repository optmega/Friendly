//
//  FRBaseRoom+CoreDataProperties.h
//  Friendly
//
//  Created by Sergey on 28.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRBaseRoom.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRBaseRoom (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isNewMessage;
@property (nullable, nonatomic, retain) NSString *currentUserId;
@property (nullable, nonatomic, retain) NSString *lastMessage;
@property (nullable, nonatomic, retain) NSDate *lastMessageDate;
@property (nullable, nonatomic, retain) NSString *roomTitle;
@property (nullable, nonatomic, retain) NSNumber *isGroupChat;
@property (nullable, nonatomic, retain) NSDate* lastActivityAt;

@end

NS_ASSUME_NONNULL_END
