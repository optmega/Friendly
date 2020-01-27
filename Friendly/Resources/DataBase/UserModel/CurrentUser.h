//
//  CurrentUser.h
//  Friendly
//
//  Created by Dmitry on 25.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface CurrentUser : UserEntity

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "CurrentUser+CoreDataProperties.h"
#import "FREvent.h"
#import "CurrentUser+Create.h"