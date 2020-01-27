//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsWireframe.h"
#import "FRFriendsEventsInteractor.h"
#import "FRFriendsEventsVC.h"
#import "FRFriendsEventsPresenter.h"
#import "FRJoinEventViewController.h"
#import "FRShareEventViewController.h"
#import "FREventPreviewController.h"
#import "FRUserProfileWireframe.h"
#import "FRMyProfileWireframe.h"
#import "FRTransitionAnimator.h"
#import "FRRecommendedUsersWireframe.h"


@interface FRFriendsEventsWireframe ()

@property (nonatomic, weak) FRFriendsEventsPresenter* presenter;
@property (nonatomic, weak) FRFriendsEventsVC* friendsEventsController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRFriendsEventsWireframe

- (void)presentFriendsEventsControllerFromNavigationController:(UINavigationController*)nc
{
    FRFriendsEventsVC* friendsEventsController = [FRFriendsEventsVC new];
    FRFriendsEventsInteractor* interactor = [FRFriendsEventsInteractor new];
    FRFriendsEventsPresenter* presenter = [FRFriendsEventsPresenter new];
    
    interactor.output = presenter;
    
    friendsEventsController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:friendsEventsController];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:friendsEventsController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.friendsEventsController = friendsEventsController;
}

- (void)dismissFriendsEventsController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentUserProfile:(UserEntity*)user
{
    if ([user.user_id isEqualToString:[FRUserManager sharedInstance].userId]) {
        [[FRMyProfileWireframe new] presentMyProfileWithAnimationFrom:self.friendsEventsController];
        
    } else {
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self.friendsEventsController user:user fromLoginFlow:NO];
         //presentUserProfileControllerFromNavigationController:self.presentedController user:user withAnimation:YES];
    }
}

- (void)presentJoinController:(FREvent*)event
{
    FRJoinEventViewController* joinController = [FRJoinEventViewController new];
    joinController.heightFooter = 255;
    joinController.delegate = (id<FRJoinEventViewControllerDelegate>)self.presenter;
//    [joinController updateWithEventId:eventId];
    [joinController updateWithEvent:event];
    [self.friendsEventsController presentViewController:joinController animated:YES completion:nil];
}

- (void)presentShareControllerWithEvent:(FREvent*)event
{
    FRShareEventViewController* shareVC = [FRShareEventViewController new];
    [shareVC updateWithEvent:event];
    
    [self.presentedController presentViewController:shareVC animated:YES completion:nil];
    
}

- (void)presentEventController:(FREvent*)event fromFrame:(CGRect)frame
{
    self.friendsEventsController.willShowEventPreview = true;
    
    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:frame];
    vc.event = event;
    
    @weakify(self);
    vc.complite = ^{
        @strongify(self);
        self.friendsEventsController.willShowEventPreview = false;
    };
    
    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:vc];
        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
        nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    nv.navigationBarHidden = YES;
   
    
    
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    
    [[FRTransitionAnimator new] presentViewController:nv from:self.friendsEventsController];

}

- (void)showAddUser {
    [[FRRecommendedUsersWireframe new] presentAddFriendsControllerFrom:(UINavigationController*)self.friendsEventsController];
}


@end
