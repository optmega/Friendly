//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishInteractorIO.h"
#import "FRProfilePolishWireframe.h"
#import "FRProfilePolishViewInterface.h"
#import "FRProfilePolishModuleDelegate.h"
#import "FRProfilePolishModuleInterface.h"

@interface FRProfilePolishPresenter : NSObject <FRProfilePolishInteractorOutput, FRProfilePolishModuleInterface>

@property (nonatomic, strong) id<FRProfilePolishInteractorInput> interactor;
@property (nonatomic, strong) FRProfilePolishWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRProfilePolishViewInterface>* userInterface;
@property (nonatomic, weak) id<FRProfilePolishModuleDelegate> profilePolishModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRProfilePolishViewInterface>*)userInterface interests:(NSArray*)interests;

@end
