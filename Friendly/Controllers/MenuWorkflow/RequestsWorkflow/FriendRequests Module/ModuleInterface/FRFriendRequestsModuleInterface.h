//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@protocol FRFriendRequestsModuleInterface <NSObject>

- (void)backSelected;
- (void)showAddFriends;
- (void)viewWillApear;
- (void)showUserProfileWithUserId:(NSString*)userId;

@end
