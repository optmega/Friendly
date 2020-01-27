//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersInteractorIO.h"
#import "FRRecommendedUsersWireframe.h"
#import "FRRecommendedUsersViewInterface.h"
#import "FRRecommendedUsersModuleDelegate.h"
#import "FRRecommendedUsersModuleInterface.h"

@interface FRRecommendedUsersPresenter : NSObject <FRRecommendedUsersInteractorOutput, FRRecommendedUsersModuleInterface>

@property (nonatomic, strong) id<FRRecommendedUsersInteractorInput> interactor;
@property (nonatomic, strong) FRRecommendedUsersWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRRecommendedUsersViewInterface>* userInterface;
@property (nonatomic, weak) id<FRRecommendedUsersModuleDelegate> recommendedUsersModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRRecommendedUsersViewInterface>*)userInterface users:(FRRecomendedUserModels*)users;

@end
