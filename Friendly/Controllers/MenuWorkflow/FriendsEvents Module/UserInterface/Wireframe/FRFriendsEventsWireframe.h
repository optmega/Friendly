//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREvent;

@interface FRFriendsEventsWireframe : NSObject

- (void)presentFriendsEventsControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissFriendsEventsController;

- (void)presentUserProfile:(UserEntity*)user;
- (void)presentJoinController:(FREvent*)event;

- (void)presentShareControllerWithEvent:(FREvent*)event;
- (void)presentEventController:(FREvent*)event fromFrame:(CGRect)frame;
- (void)showAddUser;
@end
