//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterViewInterface.h"
#import "FREventFilterModuleInterface.h"
#import "FRBaseVC.h"

@interface FREventFilterVC : FRBaseVC <FREventFilterViewInterface>

@property (nonatomic, strong) id<FREventFilterModuleInterface> eventHandler;

@end
