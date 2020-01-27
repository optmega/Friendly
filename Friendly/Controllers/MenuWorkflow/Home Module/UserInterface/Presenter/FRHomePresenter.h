//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeInteractorIO.h"
#import "FRHomeWireframe.h"
#import "FRHomeViewInterface.h"
#import "FRHomeModuleDelegate.h"
#import "FRHomeModuleInterface.h"

@interface FRHomePresenter : NSObject <FRHomeInteractorOutput, FRHomeModuleInterface>

@property (nonatomic, strong) id<FRHomeInteractorInput> interactor;
@property (nonatomic, strong) FRHomeWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRHomeViewInterface>* userInterface;
@property (nonatomic, weak) id<FRHomeModuleDelegate> homeModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRHomeViewInterface>*)userInterface;

@end
