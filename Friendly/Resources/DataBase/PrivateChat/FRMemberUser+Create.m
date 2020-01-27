//
//  FRMemberUser+Create.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMemberUser+Create.h"
#import "FREventModel.h"

@implementation FRMemberUser (Create)

- (void)update:(FRJoinUser*)user
{
    self.userId = user.user_id;
    self.photo = user.photo;
    self.name = user.first_name;
}

- (void)udpateWithUser:(FRUserModel*)user
{
    self.userId = user.id;
    self.photo = user.photo;
    self.name = user.first_name;
}
@end
