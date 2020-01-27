//
//  FRMemberUser+Create.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRJoinUser, FRUserModel;

#import "FRMemberUser.h"

@interface FRMemberUser (Create)

- (void)update:(FRJoinUser*)user;
- (void)udpateWithUser:(FRUserModel*)user;

@end
