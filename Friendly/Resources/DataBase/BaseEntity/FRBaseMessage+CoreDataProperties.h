//
//  FRBaseMessage+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRBaseMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRBaseMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *createDate;
@property (nullable, nonatomic, retain) NSString *creatorId;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSString *messageId;
@property (nullable, nonatomic, retain) NSNumber *messageStatus;
@property (nullable, nonatomic, retain) NSString *messageText;
@property (nullable, nonatomic, retain) NSNumber *messageType;
@property (nullable, nonatomic, retain) NSString *opponentId;
@property (nullable, nonatomic, retain) NSString *tempId;
@property (nullable, nonatomic, retain) NSString *userId;
@property (nullable, nonatomic, retain) NSString *userPhoto;


@end

NS_ASSUME_NONNULL_END
