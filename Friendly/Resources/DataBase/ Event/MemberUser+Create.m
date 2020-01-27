//
//  MemberUser+Create.m
//  Friendly
//
//  Created by Dmitry on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "MemberUser+Create.h"

@implementation MemberUser (Create)

+ (instancetype)initWithModel:(FRJoinUser*)model inContext:(NSManagedObjectContext*)context
{
    MemberUser* user = [MemberUser MR_createEntityInContext:context];
    user.photo = model.photo;
    user.userId = model.user_id;
    user.firstName = model.first_name;
    return  user;
}

@end
