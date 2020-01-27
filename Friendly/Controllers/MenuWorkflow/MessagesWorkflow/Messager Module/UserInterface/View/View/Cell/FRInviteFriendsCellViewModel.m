//
//  FRInviteFriendsCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInviteFriendsCellViewModel.h"



@implementation FRInviteFriendsCellViewModel

- (void)inviteFriendsSelected
{
    [self.delegate inviteFriendsSelected];
}

@end
