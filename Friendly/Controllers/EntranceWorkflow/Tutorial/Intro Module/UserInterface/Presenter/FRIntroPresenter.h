//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroInteractorIO.h"
#import "FRIntroWireframe.h"
#import "FRIntroViewInterface.h"
#import "FRIntroModuleDelegate.h"
#import "FRIntroModuleInterface.h"

@interface FRIntroPresenter : NSObject <FRIntroInteractorOutput, FRIntroModuleInterface>

@property (nonatomic, strong) id<FRIntroInteractorInput> interactor;
@property (nonatomic, strong) FRIntroWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRIntroViewInterface>* userInterface;
@property (nonatomic, weak) id<FRIntroModuleDelegate> introModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRIntroViewInterface>*)userInterface;

@end
