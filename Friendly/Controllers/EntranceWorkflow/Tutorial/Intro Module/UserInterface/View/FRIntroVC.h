//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroViewInterface.h"
#import "FRIntroModuleInterface.h"
#import "FRBaseVC.h"

@interface FRIntroVC : FRBaseVC <FRIntroViewInterface>

@property (nonatomic, strong) id<FRIntroModuleInterface> eventHandler;

@end
