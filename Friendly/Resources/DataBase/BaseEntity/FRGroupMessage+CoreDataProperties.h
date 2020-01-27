//
//  FRGroupMessage+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRGroupMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRGroupMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) FRGroupRoom *room;

@end

NS_ASSUME_NONNULL_END
