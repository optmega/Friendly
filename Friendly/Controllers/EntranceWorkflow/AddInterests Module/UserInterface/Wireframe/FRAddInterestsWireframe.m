//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsWireframe.h"
#import "FRAddInterestsInteractor.h"
#import "FRAddInterestsVC.h"
#import "FRAddInterestsPresenter.h"
#import "FRRecommendedUsersWireframe.h"
#import "FRProfilePolishWireframe.h"

@interface FRAddInterestsWireframe ()

@property (nonatomic, weak) FRAddInterestsPresenter* presenter;
@property (nonatomic, weak) FRAddInterestsVC* addInterestsController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRAddInterestsWireframe



- (void)presentAddInterestsControllerFromNavigationController:(UINavigationController*)nc
{
    FRAddInterestsVC* addInterestsController = [FRAddInterestsVC new];
    FRAddInterestsInteractor* interactor = [FRAddInterestsInteractor new];
    FRAddInterestsPresenter* presenter = [FRAddInterestsPresenter new];
    
    interactor.output = presenter;
    
    addInterestsController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:addInterestsController];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:addInterestsController animated:NO];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.addInterestsController = addInterestsController;
}

- (void)dismissAddInterestsController
{
    [self.presentedController popViewControllerAnimated:NO];
}

- (void)presentRecommendedUsersControllerWithInterests:(NSArray*)interests
{
    [[FRRecommendedUsersWireframe new] presentRecommendedUsersControllerFromNavigationController:self.presentedController interests:interests users:nil];
}

- (void)presentRecommendedUsersControllerUsers:(FRRecomendedUserModels*)users interests:(NSArray*)interests {
    
    [[FRRecommendedUsersWireframe new] presentRecommendedUsersControllerFromNavigationController:self.presentedController interests:interests users:users];
}

- (void)presentSettingsWithInterests:(NSArray*) interests {
    [[FRProfilePolishWireframe new] presentProfilePolishControllerFromNavigationController:self.presentedController interests:interests];
}

@end
