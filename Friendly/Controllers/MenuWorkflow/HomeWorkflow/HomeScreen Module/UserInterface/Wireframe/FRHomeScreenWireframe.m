//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenWireframe.h"
#import "FRHomeScreenInteractor.h"
#import "FRHomeScreenVC.h"
#import "FRHomeScreenPresenter.h"

@interface FRHomeScreenWireframe ()

@property (nonatomic, weak) FRHomeScreenPresenter* presenter;
@property (nonatomic, weak) FRHomeScreenVC* homeScreenController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRHomeScreenWireframe

- (void)presentHomeScreenControllerFromNavigationController:(UINavigationController*)nc
{
    nc.navigationBarHidden = YES;

    FRHomeScreenVC* homeScreenController = [FRHomeScreenVC new];
    FRHomeScreenInteractor* interactor = [FRHomeScreenInteractor new];
    FRHomeScreenPresenter* presenter = [FRHomeScreenPresenter new];
    
    interactor.output = presenter;
    
    homeScreenController.eventHandler = presenter;
    presenter.interactor = interactor;
    
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:homeScreenController];
    self.presenter = presenter;
    self.homeScreenController = homeScreenController;
    
    BSDispatchBlockToMainQueue(^{
        [UIApplication sharedApplication].keyWindow.rootViewController = homeScreenController;
    });
    
}

- (void)dismissHomeScreenController
{
    [self.presentedController popViewControllerAnimated:YES];
}

@end
