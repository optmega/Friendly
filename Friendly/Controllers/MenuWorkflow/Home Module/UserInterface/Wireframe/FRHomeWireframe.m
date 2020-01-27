//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeWireframe.h"
#import "FRHomeInteractor.h"
#import "FRHomeVC.h"
#import "FRHomePresenter.h"
#import "FREventFilterWireframe.h"
#import "FRFriendsEventsWireframe.h"
#import "FRSearchViewController.h"
#import "FRSettingsTransport.h"
#import "FRMyProfileWireframe.h"
#import "FRUserProfileWireframe.h"
#import "FRJoinEventViewController.h"
#import "FRShareEventViewController.h"
#import "FREventPreviewController.h"
#import "FRTransitionAnimator.h"
#import "FRRecommendedUsersWireframe.h"
#import <FBSDKShareKit/FBSDKAppInviteContent.h>
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>

@interface FRHomeWireframe ()

@property (nonatomic, weak) FRHomePresenter* presenter;
@property (nonatomic, weak) FRHomeVC* homeController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRHomeWireframe

- (void)presentHomeControllerFromNavigationController:(UINavigationController*)nc
{
    FRHomeVC* homeController = [FRHomeVC new];
    FRHomeInteractor* interactor = [FRHomeInteractor new];
    FRHomePresenter* presenter = [FRHomePresenter new];
    
    interactor.output = presenter;
    
    homeController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:homeController];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:homeController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.homeController = homeController;
}

- (void)dismissHomeController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentFilterController
{
    [[FREventFilterWireframe new]presentEventFilterControllerFromNavigationController:self.presentedController];
}

- (void)presentFriendsEventsController
{
    [[FRFriendsEventsWireframe new] presentFriendsEventsControllerFromNavigationController:self.presentedController];
}

- (void)presentSearchController
{
    FRSearchViewController* vc = [FRSearchViewController new];
    [self.presentedController pushViewController:vc animated:true];
}

- (void)presentUserProfile:(UserEntity*)user
{
    if ([[user user_id] isEqualToString:[[FRUserManager sharedInstance].currentUser user_id]]) {
        [[FRMyProfileWireframe new] presentMyProfileWithAnimationFrom:self.homeController];
    } else {
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self.homeController user:user fromLoginFlow:NO];
    }
}

- (void)presentJoinController:(FREvent*)event
{
    FRJoinEventViewController* joinController = [FRJoinEventViewController new];
    joinController.heightFooter = 255; //255
    joinController.delegate = (id<FRJoinEventViewControllerDelegate>)self.presenter;
    [joinController updateWithEvent:event];
    [self.homeController presentViewController:joinController animated:YES completion:nil];
}

- (void)presentShareControllerWithEvent:(FREvent*)event
{
    FRShareEventViewController* shareVC = [FRShareEventViewController new];
    [shareVC updateWithEvent:event];
    
    [self.presentedController presentViewController:shareVC animated:YES completion:nil];
    
}

- (void)presentEventController:(FREvent*)event fromFrame:(CGRect)frame
{
    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:frame];
    
    @weakify(self);
    vc.complite = ^{
        @strongify(self);
        self.homeController.willShowEventPreview = false;
        [self.homeController startTimer];
//        [self.homeController viewWillAppear:true];
        
    };
    if ([event.creator_id isEqualToString:[FRUserManager sharedInstance].userId]) {
        vc.isHostingEvent = true;
    }
    vc.event = event;
    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:vc];
    nv.navigationBarHidden = YES;
 
 
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    
    [[FRTransitionAnimator new] presentViewController:nv from:self.homeController];

}

- (void)showAddFriendsController {
    
    
    [FRSettingsTransport getInviteUrl:^(NSString *url) {
        
        FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
        content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://image.prntscr.com/image/d6d9e0d621b44c32a4c005d19d069652.png"];
        
        content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:url]];
        [FBSDKAppInviteDialog showFromViewController:self.homeController
                                         withContent:content
                                            delegate:nil];
        
    } failure:^(NSError *error) {
        NSLog(@"Error - %@", error.localizedDescription);
    }];
    

    //[[FRRecommendedUsersWireframe new] presentAddFriendsControllerFrom:self.presentedController];

}


@end
