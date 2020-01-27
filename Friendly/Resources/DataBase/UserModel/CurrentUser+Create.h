//
//  CurrentUser+Create.h
//  Friendly
//
//  Created by Dmitry on 25.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "CurrentUser.h"

@interface CurrentUser (Create)

+ (instancetype)initWithUserModel:(FRUserModel *)userModel inContext:(NSManagedObjectContext *)context;

@end
