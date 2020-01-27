//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREvent;

@interface FRHomeWireframe : NSObject

- (void)presentHomeControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissHomeController;

- (void)presentFilterController;
- (void)presentFriendsEventsController;
- (void)presentSearchController;

- (void)presentUserProfile:(UserEntity*)user;
- (void)presentJoinController:(FREvent*)event;

- (void)presentShareControllerWithEvent:(FREvent*)event;
- (void)presentEventController:(FREvent*)event fromFrame:(CGRect)frame;
- (void)showAddFriendsController;

@end
