//
//  MutualUser.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class UserEntity;

NS_ASSUME_NONNULL_BEGIN

@interface MutualUser : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "MutualUser+CoreDataProperties.h"
#import "MutualUser+Create.h"