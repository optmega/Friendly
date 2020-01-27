//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleInteractorIO.h"
#import "FRSearchDiscoverPeopleWireframe.h"
#import "FRSearchDiscoverPeopleViewInterface.h"
#import "FRSearchDiscoverPeopleModuleDelegate.h"
#import "FRSearchDiscoverPeopleModuleInterface.h"

@interface FRSearchDiscoverPeoplePresenter : NSObject <FRSearchDiscoverPeopleInteractorOutput, FRSearchDiscoverPeopleModuleInterface>

@property (nonatomic, strong) id<FRSearchDiscoverPeopleInteractorInput> interactor;
@property (nonatomic, strong) FRSearchDiscoverPeopleWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRSearchDiscoverPeopleViewInterface>* userInterface;
@property (nonatomic, weak) id<FRSearchDiscoverPeopleModuleDelegate> searchDiscoverPeopleModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRSearchDiscoverPeopleViewInterface>*)userInterface tag:(NSString*)tag;

@end
