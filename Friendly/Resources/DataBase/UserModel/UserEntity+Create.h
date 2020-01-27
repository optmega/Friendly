//
//  UserEntity+Create.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "UserEntity.h"
#import "FRUserModel.h"

@interface UserEntity (Create)

+ (instancetype)initWithUserModel:(FRUserModel*)userModel;
- (void)update:(FRUserModel*)userModel;
+ (instancetype)initWithUserModel:(FRUserModel*)userModel inContext:(NSManagedObjectContext*)context;

@end
