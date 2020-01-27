//
//  MutualUser+Create.m
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "MutualUser+Create.h"

@implementation MutualUser (Create)

+ (instancetype)initWithModel:(FRMutualFriend*)mutual inContext:(NSManagedObjectContext*)context
{
    MutualUser* model = [MutualUser MR_createEntityInContext:context];
    model.userId = mutual.id;
    model.firstName = mutual.first_name;
    model.photo = mutual.photo;
    model.thumbnail = mutual.thumbnail;
    return model;
}

- (FRMutualFriend*)mutualFriends
{
    FRMutualFriend* mutual = [FRMutualFriend new];
    mutual.id = self.userId;
    mutual.first_name = self.firstName;
    mutual.photo = self.photo;
    mutual.thumbnail = self.thumbnail;
    
    return mutual;
}
@end
