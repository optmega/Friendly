//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsWireframe.h"
#import "FRFriendRequestsInteractor.h"
#import "FRFriendRequestsVC.h"
#import "FRFriendRequestsPresenter.h"
#import "FRUserProfileWireframe.h"
#import "FRRecommendedUsersWireframe.h"

@interface FRFriendRequestsWireframe ()

@property (nonatomic, weak) FRFriendRequestsPresenter* presenter;
@property (nonatomic, weak) FRFriendRequestsVC* friendRequestsController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRFriendRequestsWireframe

- (void)presentFriendRequestsControllerFromNavigationController:(UINavigationController*)nc
{
    FRFriendRequestsVC* friendRequestsController = [FRFriendRequestsVC new];
    FRFriendRequestsInteractor* interactor = [FRFriendRequestsInteractor new];
    FRFriendRequestsPresenter* presenter = [FRFriendRequestsPresenter new];
    
    interactor.output = presenter;
    
    friendRequestsController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:friendRequestsController];
    
    BSDispatchBlockToMainQueue(^{
        CATransition* transition = [CATransition animation];
        transition.duration = 0.4;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionMoveIn; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
        transition.subtype = kCATransitionFromTop; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
        [nc.view.layer addAnimation:transition forKey:nil];
        
        [nc presentViewController:friendRequestsController animated:true completion:nil];

        
//        [nc pushViewController:friendRequestsController animated:NO];
//        [nc presentViewController:friendRequestsController animated:YES completion:nil];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.friendRequestsController = friendRequestsController;
}

- (void)dismissFriendRequestsController
{
    
    [self.friendRequestsController dismissViewControllerAnimated:true completion:nil];
    
    return;
//    CATransition* transition = [CATransition animation];
//    transition.duration = 0.4;
//    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
//    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
//    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
//    [self.presentedController.view.layer addAnimation:transition forKey:nil];
//    [self.presentedController popToRootViewControllerAnimated:NO];

}

- (void)showUserProfileWithEntity:(UserEntity*)user
{
    FRUserProfileWireframe* uwf = [FRUserProfileWireframe new];
    
    self.friendRequestsController.statusBarColor = UIStatusBarStyleLightContent;
    [self.friendRequestsController setNeedsStatusBarAppearanceUpdate];
    @weakify(self);
    uwf.complite = ^{
        @strongify(self);
        self.friendRequestsController.statusBarColor = UIStatusBarStyleDefault;
        [self.friendRequestsController setNeedsStatusBarAppearanceUpdate];
    };
    
    [uwf presentUserProfileFromViewController:self.friendRequestsController user:user fromLoginFlow:NO];
    
}

- (void)showAddFriends {
    [[FRRecommendedUsersWireframe new] presentAddFriendsControllerFrom:(UINavigationController*)self.friendRequestsController];
}

@end
