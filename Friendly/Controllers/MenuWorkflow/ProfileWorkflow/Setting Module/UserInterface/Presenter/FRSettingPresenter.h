//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingInteractorIO.h"
#import "FRSettingWireframe.h"
#import "FRSettingViewInterface.h"
#import "FRSettingModuleDelegate.h"
#import "FRSettingModuleInterface.h"

@interface FRSettingPresenter : NSObject <FRSettingInteractorOutput, FRSettingModuleInterface>

@property (nonatomic, strong) id<FRSettingInteractorInput> interactor;
@property (nonatomic, strong) FRSettingWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRSettingViewInterface>* userInterface;
@property (nonatomic, weak) id<FRSettingModuleDelegate> settingModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRSettingViewInterface>*)userInterface;

@end
