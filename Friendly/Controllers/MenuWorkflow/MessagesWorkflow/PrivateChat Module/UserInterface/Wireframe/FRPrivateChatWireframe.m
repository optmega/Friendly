//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatWireframe.h"
#import "FRPrivateChatInteractor.h"
#import "FRPrivateChatVC.h"
#import "FRPrivateChatPresenter.h"
#import "FRUserProfileWireframe.h"
#import "FRMyProfileWireframe.h"
#import "FREventPreviewController.h"
#import "FRTransitionAnimator.h"

@interface FRPrivateChatWireframe ()

@property (nonatomic, weak) FRPrivateChatPresenter* presenter;
@property (nonatomic, weak) FRPrivateChatVC* privateChatController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRPrivateChatWireframe

- (void)presentPrivateChatControllerFromNavigation:(UINavigationController*)nc forEvent:(FREvent*)eventT {
    if (!eventT) {
        return;
    }
    FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:eventT.objectID];
    FRPrivateChatVC* privateChatController = [FRPrivateChatVC new];
    FRPrivateChatInteractor* interactor = [FRPrivateChatInteractor new];
    FRPrivateChatPresenter* presenter = [FRPrivateChatPresenter new];
    
    interactor.output = presenter;
    
    privateChatController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:privateChatController event:event];
    
    UINavigationController* navControler = [[UINavigationController alloc]initWithRootViewController:privateChatController];
    nc.navigationBarHidden = true;
    navControler.navigationBarHidden = true;
    
    BSDispatchBlockToMainQueue(^{
//        [nc pushViewController:privateChatController animated:YES];
        
        [nc presentViewController:navControler animated:YES completion:nil];
    });
    
    self.presenter = presenter;
    self.presentedController = navControler;
    self.privateChatController = privateChatController;
}

- (void)dismissPrivateChatController
{
    [self.privateChatController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentUserProfile:(UserEntity*)user
{
    NSString* firstId = [[user user_id] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString* secondId = [[[FRUserManager sharedInstance].currentUser user_id] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    
    if (![firstId isEqualToString:secondId]){
       
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self.presentedController user:user fromLoginFlow:true];
        return;
    }
    [[FRMyProfileWireframe new] presentMyProfileControllerFromNavigationController:self.privateChatController.navigationController withBackButton:true];
}

- (void)presentEventControllerWithEventId:(NSString*)eventId
{
    
}

- (void)showEvent:(FREvent*)event {
    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEvent:event fromFrame:CGRectZero];
    if ([event.creator_id isEqualToString:[FRUserManager sharedInstance].userId]) {
        vc.isHostingEvent = true;
    }
    
    self.privateChatController.willShowEventPreview = true;
  
    @weakify(self);
    vc.complite = ^{
        @strongify(self);
        self.privateChatController.willShowEventPreview = false;
    };
    vc.event = event;
    vc.isFromEvent = true;
    
    UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:vc];
    nv.navigationBarHidden = true;
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    
    [self.presentedController presentViewController:nv animated:YES completion:nil];
}


@end
