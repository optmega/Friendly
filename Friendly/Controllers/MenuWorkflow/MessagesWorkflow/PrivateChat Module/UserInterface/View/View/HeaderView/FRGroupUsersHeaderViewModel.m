//
//  FRGroupUsersHeaderViewModel.m
//  Friendly
//
//  Created by Sergey on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupUsersHeaderViewModel.h"
#import "FRDateManager.h"

@implementation FRGroupUsersHeaderViewModel

- (void)selectedUserId:(NSString *)userId
{
    [self.delegate selectedUsersId:userId];
}

- (NSString*)subtitle{
    
    if (self.dateJoined) {
        return [NSString stringWithFormat:@"YOU JOINED ON THE %@", [FRDateManager dateStringFromDate:self.dateJoined withFormat:@"MM/dd/yyyy"]];
    }
    return @"";
}
@end
