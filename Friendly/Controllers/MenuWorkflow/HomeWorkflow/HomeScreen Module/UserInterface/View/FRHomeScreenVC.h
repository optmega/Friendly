//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenViewInterface.h"
#import "FRHomeScreenModuleInterface.h"
#import "FRBaseVC.h"

@interface FRHomeScreenVC : UITabBarController <FRHomeScreenViewInterface>

@property (nonatomic, strong) id<FRHomeScreenModuleInterface> eventHandler;

@end
