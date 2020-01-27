//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterInteractorIO.h"
#import "FREventFilterWireframe.h"
#import "FREventFilterViewInterface.h"
#import "FREventFilterModuleDelegate.h"
#import "FREventFilterModuleInterface.h"

@interface FREventFilterPresenter : NSObject <FREventFilterInteractorOutput, FREventFilterModuleInterface>

@property (nonatomic, strong) id<FREventFilterInteractorInput> interactor;
@property (nonatomic, strong) FREventFilterWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FREventFilterViewInterface>* userInterface;
@property (nonatomic, weak) id<FREventFilterModuleDelegate> eventFilterModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FREventFilterViewInterface>*)userInterface;

@end
