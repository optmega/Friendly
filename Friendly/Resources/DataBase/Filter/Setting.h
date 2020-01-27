//
//  Setting.h
//  Friendly
//
//  Created by Sergey on 07.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface Setting : NSManagedObject

// Insert code here to declare functionality of your managed object subclass
- (BOOL)isEqualToSetting:(Setting *)setting;

@end

NS_ASSUME_NONNULL_END

#import "Setting+CoreDataProperties.h"
#import "Setting+Create.h"