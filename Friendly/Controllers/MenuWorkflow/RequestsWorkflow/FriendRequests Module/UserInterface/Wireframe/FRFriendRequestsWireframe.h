//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRFriendRequestsWireframe : NSObject

- (void)presentFriendRequestsControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissFriendRequestsController;
- (void)showUserProfileWithEntity:(UserEntity*)user;
- (void)showAddFriends;

@end
