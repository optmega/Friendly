//
//  FRPrivateMessage+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FRPrivateMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRPrivateMessage (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *roomId;
@property (nullable, nonatomic, retain) FRPrivateRoom *room;

@end

NS_ASSUME_NONNULL_END
