//
//  UserRequest+Create.m
//  Friendly
//
//  Created by Dmitry on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "UserRequest+Create.h"
#import "FRDateManager.h"

@implementation UserRequest (Create)

+ (instancetype)initWithModel:(FRRequestsUser*)model inContext:(NSManagedObjectContext *)context
{
    UserRequest* user = [UserRequest MR_createEntityInContext:context];
    user.photo = model.photo;
    user.userId = model.user_id;
    user.firstName = model.first_name;
    user.birthday = [FRDateManager dateFromBirthdayFormat:model.birthday];
    user.requestMessage = model.request_message;
    user.createdAt = [FRDateManager dateFromServerWithString:model.created_at];
    user.way = @(model.way.integerValue);
    user.requestId = model.request_id;
    
    return user;
}

@end

