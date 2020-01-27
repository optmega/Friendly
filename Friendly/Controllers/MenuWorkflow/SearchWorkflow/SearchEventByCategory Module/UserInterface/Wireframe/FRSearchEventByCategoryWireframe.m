//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryWireframe.h"
#import "FRSearchEventByCategoryInteractor.h"
#import "FRSearchEventByCategoryVC.h"
#import "FRSearchEventByCategoryPresenter.h"
#import "FRSearchDiscoverPeopleWireframe.h"
#import "FREventPreviewController.h"
#import "FREventModel.h"
#import "FRUserProfileWireframe.h"
#import "FRMyProfileWireframe.h"
#import "FRUserManager.h"
#import "FREventFilterWireframe.h"
#import "FRShareEventViewController.h"
#import "FRTransitionAnimator.h"
#import "FRJoinEventViewController.h"
#import "FREventPreviewController.h"

@interface FRSearchEventByCategoryWireframe ()

@property (nonatomic, weak) FRSearchEventByCategoryPresenter* presenter;
@property (nonatomic, weak) FRSearchEventByCategoryVC* searchEventByCategoryController;
@property (nonatomic, weak) UINavigationController* presentedController;
@property (nonatomic, strong) NSString* category;

@end

@implementation FRSearchEventByCategoryWireframe

- (void)presentSearchEventByCategoryControllerFromNavigationController:(UINavigationController*)nc category:(NSString*)category
{
    FRSearchEventByCategoryVC* searchEventByCategoryController = [FRSearchEventByCategoryVC new];
    FRSearchEventByCategoryInteractor* interactor = [FRSearchEventByCategoryInteractor new];
    FRSearchEventByCategoryPresenter* presenter = [FRSearchEventByCategoryPresenter new];
    
    interactor.output = presenter;
    
    searchEventByCategoryController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:searchEventByCategoryController category:category];
    self.category = category;
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:searchEventByCategoryController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.searchEventByCategoryController = searchEventByCategoryController;
}

- (void)dismissSearchEventByCategoryController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentSearchDiscoverPeopleControllerWithTag:(NSString*)tag
{
    if (tag)
    {
        [[FRSearchDiscoverPeopleWireframe new] presentSearchDiscoverPeopleControllerFromNavigationController:self.presentedController tag:tag];
    }
}

- (void)presentJoinController:(NSString*)eventId event:(FREvent*)event
{
    FRJoinEventViewController* joinController = [FRJoinEventViewController new];
    joinController.heightFooter = 255;
    joinController.delegate = (id<FRJoinEventViewControllerDelegate>)self.presenter;
    [joinController updateWithEventId:eventId];
    [joinController updateWithEvent:event];
    [self.searchEventByCategoryController presentViewController:joinController animated:YES completion:nil];
}


- (void)presentPreviewEvent:(FREvent*)event
{
    FREventPreviewController* previewController = [[FREventPreviewController alloc] initWithEvent:event fromFrame:CGRectZero];
    UINavigationController* nVC = [[UINavigationController alloc] initWithRootViewController:previewController];
    nVC.navigationBarHidden = YES;
    nVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

//    nVC.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [[FRTransitionAnimator new] presentViewController:nVC from:self.searchEventByCategoryController];

    [self.searchEventByCategoryController presentViewController:nVC animated:YES completion:nil];
}

- (void)showShareController:(FREvent*)event
{
    FRShareEventViewController* shareVC = [[FRShareEventViewController alloc] init];
    [shareVC updateWithEvent:event];
    [self.searchEventByCategoryController presentViewController:shareVC animated:YES completion:nil];
}

- (void)presentUserProfile:(UserEntity *)user {
    if ([[FRUserManager sharedInstance].userId isEqualToString:user.user_id])
    {
        [[FRMyProfileWireframe new] presentMyProfileWithAnimationFrom:self.searchEventByCategoryController];
    } else {
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self.searchEventByCategoryController user:user fromLoginFlow:false];
    }
}

- (void)showUserProfileController:(NSString*)userId
{
   if ([[FRUserManager sharedInstance].userModel.id isEqualToString:userId])
   {
       [[FRMyProfileWireframe new] presentMyProfileWithAnimationFrom:self.searchEventByCategoryController];
   }
    else
    {
        //TODO: нужно передавать UserEntity 
//        [[FRUserProfileWireframe new] presentUserProfileControllerFromNavigationController:self.presentedController userId:userId];
    }
}

- (void)presentFilterController
{
    [[FREventFilterWireframe new] presentEventFilterControllerFromNavigationController:self.presentedController];
}

- (void)showEventPreviewWithEvent:(FREvent *)event fromFrame:(CGRect)frame
{
    FREventPreviewController* eventPreviewVC = [[FREventPreviewController alloc] initWithEvent:event fromFrame:frame];
    
    eventPreviewVC.complite = ^{
        BSDispatchBlockAfter(0.3, ^{
            
            setStatusBarColor([UIColor blackColor]);
        });
    };
    
    eventPreviewVC.isFromEvent = YES;
    UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:eventPreviewVC];
    nv.navigationBarHidden = YES;
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    //        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [self.presentedController presentViewController:nv animated:YES completion:nil];
}

@end
