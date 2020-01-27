//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsInteractorIO.h"
#import "FRAddInterestsWireframe.h"
#import "FRAddInterestsViewInterface.h"
#import "FRAddInterestsModuleDelegate.h"
#import "FRAddInterestsModuleInterface.h"

@interface FRAddInterestsPresenter : NSObject <FRAddInterestsInteractorOutput, FRAddInterestsModuleInterface>

@property (nonatomic, strong) id<FRAddInterestsInteractorInput> interactor;
@property (nonatomic, strong) FRAddInterestsWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRAddInterestsViewInterface>* userInterface;
@property (nonatomic, weak) id<FRAddInterestsModuleDelegate> addInterestsModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRAddInterestsViewInterface>*)userInterface;

@end
