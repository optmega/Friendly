//
//  FREvent.h
//  Friendly
//
//  Created by Dmitry on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "MemberUser.h"
#import "UserRequest.h"

@class UserEntity;
@class FRGroupRoom;

NS_ASSUME_NONNULL_BEGIN

@interface FREvent : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "FREvent+CoreDataProperties.h"
#import "FREvent+Create.h"