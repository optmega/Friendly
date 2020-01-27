//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerWireframe.h"
#import "FRMessagerInteractor.h"
#import "FRMessagerVC.h"
#import "FRMessagerPresenter.h"
#import "FRFriendRequestsWireframe.h"
#import "FRPrivateChatWireframe.h"
#import "FRPrivateRoomChatWireframe.h"
#import "FRGroupRoom.h"
#import "FRUserProfileWireframe.h"
#import "FRSearchViewController.h"
#import "FRRecommendedUsersWireframe.h"

@interface FRMessagerWireframe ()

@property (nonatomic, weak) FRMessagerPresenter* presenter;
@property (nonatomic, weak) FRMessagerVC* messagerController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRMessagerWireframe

- (void)presentMessagerControllerFromNavigationController:(UINavigationController*)nc
{
    FRMessagerVC* messagerController = [FRMessagerVC new];
    FRMessagerInteractor* interactor = [FRMessagerInteractor new];
    FRMessagerPresenter* presenter = [FRMessagerPresenter new];
    
    interactor.output = presenter;
    
    messagerController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:messagerController];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:messagerController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.messagerController = messagerController;
}

- (void)dismissMessagerController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentFriendRequest
{
    [[FRFriendRequestsWireframe new]presentFriendRequestsControllerFromNavigationController:self.presentedController];
}

- (void)showAddUser {
    [[FRRecommendedUsersWireframe new] presentAddFriendsControllerFrom:(UINavigationController*)self.messagerController];
}

- (void)presentPrivateChatWithUser:(UserEntity*)user {
    [[FRPrivateRoomChatWireframe new] presentPrivateRoomChatControllerFromNavigationController:self.presentedController userEntity:user];
}

- (void)presentUserProfile:(UserEntity*)user
{
    
    [[FRUserProfileWireframe new] presentUserProfileFromViewController:self.presentedController user:user fromLoginFlow:true];
}

- (void)presentGroupChat:(FRGroupRoom*)room
{
    [[FRPrivateChatWireframe new] presentPrivateChatControllerFromNavigation:self.presentedController forEvent:[room event]];
}

- (void)showSearchController {
    FRSearchViewController* vc = [FRSearchViewController new];
    [self.presentedController pushViewController:vc animated:true];
}
@end
