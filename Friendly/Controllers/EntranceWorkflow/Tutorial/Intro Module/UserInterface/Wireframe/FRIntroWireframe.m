//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroWireframe.h"
#import "FRIntroInteractor.h"
#import "FRIntroVC.h"
#import "FRIntroPresenter.h"
#import "FRLetsGoVC.h"
#import "FRHomeScreenWireframe.h"

@interface FRIntroWireframe ()

@property (nonatomic, weak) FRIntroPresenter* presenter;

@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRIntroWireframe

- (void)presentIntroControllerFromNavigationController:(UINavigationController*)nc
{

    nc.navigationBarHidden = YES;
    
    FRIntroVC* introController = [FRIntroVC new];
    FRIntroInteractor* interactor = [FRIntroInteractor new];
    FRIntroPresenter* presenter = [FRIntroPresenter new];
    
    interactor.output = presenter;
    
    introController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:introController];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:introController animated:NO];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.introController = introController;
}

- (void)presentLetsGoController
{
    FRLetsGoVC* vc = [FRLetsGoVC new];
    UINavigationController* nc = [[UINavigationController alloc]initWithRootViewController:vc];
    nc.navigationBarHidden = YES;
    [UIApplication sharedApplication].keyWindow.rootViewController = nc;
}

- (void) presentHomeScreen
{
    FRHomeScreenWireframe* wf = [FRHomeScreenWireframe new];
    [wf presentHomeScreenControllerFromNavigationController:self.presentedController];
}

- (void)dismissIntroController
{
    [self.presentedController popViewControllerAnimated:NO];
}

@end
