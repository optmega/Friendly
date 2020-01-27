//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenInteractorIO.h"
#import "FRHomeScreenWireframe.h"
#import "FRHomeScreenViewInterface.h"
#import "FRHomeScreenModuleDelegate.h"
#import "FRHomeScreenModuleInterface.h"

@interface FRHomeScreenPresenter : NSObject <FRHomeScreenInteractorOutput, FRHomeScreenModuleInterface>

@property (nonatomic, strong) id<FRHomeScreenInteractorInput> interactor;
@property (nonatomic, strong) FRHomeScreenWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRHomeScreenViewInterface>* userInterface;
@property (nonatomic, weak) id<FRHomeScreenModuleDelegate> homeScreenModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRHomeScreenViewInterface>*)userInterface;

@end
