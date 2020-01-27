//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsViewInterface.h"
#import "FREventsModuleInterface.h"
#import "FRBaseVC.h"

@interface FREventsVC : FRBaseVC <FREventsViewInterface>

@property (nonatomic, strong) id<FREventsModuleInterface> eventHandler;

@end
