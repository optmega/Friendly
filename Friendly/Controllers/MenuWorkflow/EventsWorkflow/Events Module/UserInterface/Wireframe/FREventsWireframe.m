//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsWireframe.h"
#import "FREventsInteractor.h"
#import "FREventsVC.h"
#import "FREventsPresenter.h"
#import "FRMyProfileWireframe.h"
#import "FREventPreviewController.h"
#import "FRUserProfileWireframe.h"
#import "FRJoinEventViewController.h"
#import "FREventFilterWireframe.h"
#import "FRShareEventViewController.h"

#import "FRTransitionAnimator.h"


@interface FREventsWireframe ()

@property (nonatomic, weak) FREventsPresenter* presenter;
//@property (nonatomic, weak) FREventsVC* eventsController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FREventsWireframe

- (void)presentEventsControllerFromNavigationController:(UINavigationController*)nc
{
    FREventsVC* eventsController = [FREventsVC new];
    FREventsInteractor* interactor = [FREventsInteractor new];
    FREventsPresenter* presenter = [FREventsPresenter new];
    
    interactor.output = presenter;
    
    eventsController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:eventsController];
    
    BSDispatchBlockToMainQueue(^{
//        [nc pushViewController:eventsController animated:YES];
        nc.viewControllers = @[eventsController];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.eventsController = eventsController;
}

- (void)dismissEventsController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentProfileController
{
    [[FRMyProfileWireframe new] presentMyProfileWithAnimationFrom:self.eventsController];
}

- (void)presentPreviewControllerWithEvent:(FREventModel*)event image:(UIImage*)imageEvent
{
//    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEventId:event.id andModel:event];
//    vc.event = event;
//    vc.eventImage = imageEvent;
//    vc.delegate = (id<FREventPreviewControllerDelegate>)self.eventsController;
//    vc.temp = self.eventsController;
//    UINavigationController* nv = [[UINavigationController alloc]initWithRootViewController:vc];
////    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
////    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    nv.navigationBarHidden = YES;
//    //    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:cellViewModel.backImage]]];
//    //    vc.eventImage = image;
//    
////    [self.eventsController presentViewController:nv animated:YES completion:^{
////
////    }];
//
//
//    [[FRTransitionAnimator new] presentViewController:nv from:self.eventsController];
}

- (void)presentProfileUserControlletWithUserId:(NSString*)userId 
{
//    [[FRUserProfileWireframe new] presentUserProfileControllerFromNavigationController:self.presentedController userId:userId];
}

- (void)presentJoinController:(NSString*)eventId
{
    FRJoinEventViewController* joinController = [FRJoinEventViewController new];
    joinController.heightFooter = 255;
    joinController.delegate = (id<FRJoinEventViewControllerDelegate>)self.presenter;
    [joinController updateWithEventId:eventId];
    [self.eventsController presentViewController:joinController animated:YES completion:nil];
}

- (void)presentFilterController
{
    [[FREventFilterWireframe new]presentEventFilterControllerFromNavigationController:self.presentedController];
}

- (void)presentShareControllerWithEvent:(FREvent*)event
{
    FRShareEventViewController* shareVC = [FRShareEventViewController new];
    [shareVC updateWithEvent:event];
    
    [self.presentedController presentViewController:shareVC animated:YES completion:nil];
    
}

@end
