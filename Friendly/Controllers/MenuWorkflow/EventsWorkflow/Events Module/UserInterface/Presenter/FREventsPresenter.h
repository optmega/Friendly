//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsInteractorIO.h"
#import "FREventsWireframe.h"
#import "FREventsViewInterface.h"
#import "FREventsModuleDelegate.h"
#import "FREventsModuleInterface.h"


@interface FREventsPresenter : NSObject <FREventsInteractorOutput, FREventsModuleInterface>

@property (nonatomic, strong) id<FREventsInteractorInput> interactor;
@property (nonatomic, strong) FREventsWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FREventsViewInterface>* userInterface;
@property (nonatomic, weak) id<FREventsModuleDelegate> eventsModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FREventsViewInterface>*)userInterface;

@end
