//
//  FRRootWireframe.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRootWireframe.h"
#import "FRIntroWireframe.h"
#import "FRSplashVC.h"
#import "FRHomeScreenWireframe.h"

@implementation FRRootWireframe

- (void)showRootViewController:(UIViewController *)viewController inWindow:(UIWindow *)window
{
    UINavigationController *navigationController = [self navigationControllerFromWindow:window];
    navigationController.viewControllers = @[viewController];
    
    window.rootViewController = navigationController;
}

- (UINavigationController *)navigationControllerFromWindow:(UIWindow *)window
{
    UINavigationController *navigationController = (UINavigationController *)[window rootViewController].navigationController;
    if (!navigationController)
    {
        navigationController = [UINavigationController new];
    }
    navigationController.navigationBarHidden = YES;
    return navigationController;
}

- (void)showIntroController:(UIWindow*)window
{
    //firstcontroller *first = [firstcontroller new];
    UINavigationController* nc = [self navigationControllerFromWindow:window];
    window.rootViewController = nc;
    
    nc.viewControllers = @[[FRSplashVC new]];
    
    BSDispatchBlockAfter(0, ^{
         [[FRIntroWireframe new] presentIntroControllerFromNavigationController:nc];
    });
}

- (void)showHomeController:(UIWindow*)window
{
    //firstcontroller *first = [firstcontroller new];
    UINavigationController* nc = [self navigationControllerFromWindow:window];
    window.rootViewController = nc;
    
    nc.viewControllers = @[[FRSplashVC new]];
    
    BSDispatchBlockAfter(0, ^{
        [[FRHomeScreenWireframe new] presentHomeScreenControllerFromNavigationController:nc];
    });
}

@end
