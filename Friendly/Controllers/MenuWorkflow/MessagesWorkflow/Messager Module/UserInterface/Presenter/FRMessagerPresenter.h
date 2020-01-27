//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerInteractorIO.h"
#import "FRMessagerWireframe.h"
#import "FRMessagerViewInterface.h"
#import "FRMessagerModuleDelegate.h"
#import "FRMessagerModuleInterface.h"

@interface FRMessagerPresenter : NSObject <FRMessagerInteractorOutput, FRMessagerModuleInterface>

@property (nonatomic, strong) id<FRMessagerInteractorInput> interactor;
@property (nonatomic, strong) FRMessagerWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRMessagerViewInterface>* userInterface;
@property (nonatomic, weak) id<FRMessagerModuleDelegate> messagerModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRMessagerViewInterface>*)userInterface;

@end
