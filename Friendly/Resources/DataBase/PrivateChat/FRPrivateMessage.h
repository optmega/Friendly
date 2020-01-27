//
//  FRPrivateMessage.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRBaseMessage.h"
#import "FRPrivateRoom.h"

@class FRPrivateRoom;

NS_ASSUME_NONNULL_BEGIN

@interface FRPrivateMessage : FRBaseMessage

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "FRPrivateMessage+CoreDataProperties.h"
#import "FRPrivateMessage+Create.h"
