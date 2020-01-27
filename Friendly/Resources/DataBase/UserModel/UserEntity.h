//
//  UserEntity.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@class InstagramImage, Interest, MutualUser;

NS_ASSUME_NONNULL_BEGIN

@interface UserEntity : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "UserEntity+CoreDataProperties.h"
#import "UserEntity+Create.h"
#import "Filter.h"