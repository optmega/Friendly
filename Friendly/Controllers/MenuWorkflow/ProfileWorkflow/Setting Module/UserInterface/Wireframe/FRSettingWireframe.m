//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingWireframe.h"
#import "FRSettingInteractor.h"
#import "FRSettingVC.h"
#import "FRSettingPresenter.h"
#import "FRIntroWireframe.h"

@interface FRSettingWireframe ()

@property (nonatomic, weak) FRSettingPresenter* presenter;
@property (nonatomic, weak) FRSettingVC* settingController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRSettingWireframe

- (void)presentSettingControllerFromController:(UINavigationController*)nc
{
    FRSettingVC* settingController = [FRSettingVC new];
    FRSettingInteractor* interactor = [FRSettingInteractor new];
    FRSettingPresenter* presenter = [FRSettingPresenter new];
    
    interactor.output = presenter;
    
    settingController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:settingController];
        BSDispatchBlockToMainQueue(^{
            
         UITabBarController* homeScreen =   (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
            homeScreen.tabBar.hidden = true;
            
        [nc pushViewController:settingController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.settingController = settingController;
}

- (void)dismissSettingController
{
    UITabBarController* homeScreen =   (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    homeScreen.tabBar.hidden = false;
    
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)globalDissmiss
{

    [self.settingController dismissViewControllerAnimated:NO completion:nil];
    [self.presentedController.navigationController setViewControllers:@[]];
    
    UINavigationController* nc = [[UINavigationController alloc]init];
    UITabBarController* tabController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    UINavigationController* n = [[tabController viewControllers] objectAtIndex:0];
    [n setViewControllers:@[]];
    
    
    
    [[FRIntroWireframe new] presentIntroControllerFromNavigationController:nc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nc;
    [tabController dismissViewControllerAnimated:NO completion:nil];

}

- (void)dealloc
{
    
}

+ (void)Logout {
    
    UINavigationController* nc = [[UINavigationController alloc]init];
    UITabBarController* tabController = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    
    if ([tabController isKindOfClass:[UINavigationController class]]) {
        return;
    }
    
    UINavigationController* n = [[tabController viewControllers] objectAtIndex:0];
    [n setViewControllers:@[]];
    
    FRIntroWireframe* wareframe = [FRIntroWireframe new];
    [wareframe presentIntroControllerFromNavigationController:nc];
    [UIApplication sharedApplication].keyWindow.rootViewController = nc;
    [tabController dismissViewControllerAnimated:NO completion:nil];
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Unauthorized" preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:nil]];
    
    [wareframe.introController presentViewController:alert animated:true completion:nil];
    
}

@end
