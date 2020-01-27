//
//  FRMyProfileIconCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileIconCellViewModel.h"

@implementation FRMyProfileIconCellViewModel

- (void)changeStatus:(NSInteger)status {
    [self.delegate changeStatus:status];
}

- (void)presentAddMobileController
{
    [self.delegate presentAddMobileController];
}

- (void)presentInviteFriendsController
{
    [self.delegate presentInviteFriendsController];
}

@end
