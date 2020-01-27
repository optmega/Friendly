//
//  CurrentUser+Create.m
//  Friendly
//
//  Created by Dmitry on 25.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "CurrentUser+Create.h"

@implementation CurrentUser (Create)

+ (instancetype)initWithUserModel:(FRUserModel*)userModel inContext:(NSManagedObjectContext *)context
{
    CurrentUser* model = [CurrentUser MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userModel.id] inContext:context];
    if (!model) {
        model = [CurrentUser MR_createEntityInContext:context];
    }
    
    [model update:userModel];
    
    return model;
}

@end
