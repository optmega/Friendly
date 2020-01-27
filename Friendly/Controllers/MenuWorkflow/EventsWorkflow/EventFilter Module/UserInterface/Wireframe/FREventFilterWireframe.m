//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterWireframe.h"
#import "FREventFilterInteractor.h"
#import "FREventFilterVC.h"
#import "FREventFilterPresenter.h"
#import "FRCreateEventGenderViewController.h"
#import "FREventFilterSelectDateViewController.h"
#import "FRCreateEventLocationSelectViewController.h"

@interface FREventFilterWireframe ()

@property (nonatomic, weak) FREventFilterPresenter* presenter;
@property (nonatomic, weak) FREventFilterVC* eventFilterController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FREventFilterWireframe

- (void)presentEventFilterControllerFromNavigationController:(UINavigationController*)nc
{
    FREventFilterVC* eventFilterController = [FREventFilterVC new];
    FREventFilterInteractor* interactor = [FREventFilterInteractor new];
    FREventFilterPresenter* presenter = [FREventFilterPresenter new];
    
    interactor.output = presenter;
    
    eventFilterController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:eventFilterController];
    
    BSDispatchBlockToMainQueue(^{
//        [nc pushViewController:eventFilterController animated:YES];
        [nc presentViewController:eventFilterController animated:YES completion:nil];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.eventFilterController = eventFilterController;
}

- (void)dismissEventFilterController
{
//    [self.presentedController popViewControllerAnimated:YES];
    [self.eventFilterController dismissViewControllerAnimated:YES completion:nil];
}

- (void)presentGenderVCWithGenderType:(FRGenderType)type
{
    FRCreateEventGenderViewController* genderVC = [FRCreateEventGenderViewController new];
    genderVC.genderType = type;
    genderVC.delegate = (id<FRCreateEventGenderViewControllerDelegate>)self.presenter;
    
    [self.eventFilterController presentViewController:genderVC animated:NO completion:nil];
}

- (void)presentDateVCWithDateType
{
    FREventFilterSelectDateViewController* dateVC = [FREventFilterSelectDateViewController new];
    dateVC.heightFooter = 200;
    dateVC.delegate = (id<FREventFilterSelectDateViewControllerDelegate>)self.presenter;
    [self.eventFilterController presentViewController:dateVC animated:NO completion:nil];
}

- (void)presentLocationVC
{
    FRCreateEventLocationSelectViewController* locationVC = [FRCreateEventLocationSelectViewController new];
    locationVC.delegate = (id<FRCreateEventLocationDelegate>)self.presenter;
    [self.eventFilterController presentViewController:locationVC animated:NO completion:nil];
}


@end
