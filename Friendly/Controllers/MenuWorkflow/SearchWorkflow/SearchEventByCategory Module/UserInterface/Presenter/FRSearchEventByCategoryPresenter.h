//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryInteractorIO.h"
#import "FRSearchEventByCategoryWireframe.h"
#import "FRSearchEventByCategoryViewInterface.h"
#import "FRSearchEventByCategoryModuleDelegate.h"
#import "FRSearchEventByCategoryModuleInterface.h"

@interface FRSearchEventByCategoryPresenter : NSObject <FRSearchEventByCategoryInteractorOutput, FRSearchEventByCategoryModuleInterface>

@property (nonatomic, strong) id<FRSearchEventByCategoryInteractorInput> interactor;
@property (nonatomic, strong) FRSearchEventByCategoryWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRSearchEventByCategoryViewInterface>* userInterface;
@property (nonatomic, weak) id<FRSearchEventByCategoryModuleDelegate> searchEventByCategoryModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRSearchEventByCategoryViewInterface>*)userInterface category:(NSString*)category;

@end
