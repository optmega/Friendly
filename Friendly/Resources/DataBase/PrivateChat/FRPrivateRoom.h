//
//  FRPrivateRoom.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "FRBaseRoom.h"


@class FRPrivateMessage;

NS_ASSUME_NONNULL_BEGIN

@interface FRPrivateRoom : FRBaseRoom

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "FRPrivateRoom+CoreDataProperties.h"
#import "FRPrivateRoom+Create.h"
