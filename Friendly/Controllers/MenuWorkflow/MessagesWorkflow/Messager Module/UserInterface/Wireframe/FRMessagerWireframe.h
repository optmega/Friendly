//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRMessagerWireframe : NSObject

- (void)presentMessagerControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissMessagerController;
- (void)presentFriendRequest;

- (void)presentUserProfile:(UserEntity*)user;
- (void)presentGroupChat:(FRGroupRoom*)room;
- (void)presentPrivateChatWithUser:(UserEntity*)user;
- (void)showSearchController;
- (void)showAddUser;

@end
