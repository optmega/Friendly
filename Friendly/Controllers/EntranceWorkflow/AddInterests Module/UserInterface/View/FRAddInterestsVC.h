//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsViewInterface.h"
#import "FRAddInterestsModuleInterface.h"
#import "FRBaseVC.h"

@interface FRAddInterestsVC : FRBaseVC <FRAddInterestsViewInterface>

@property (nonatomic, strong) id<FRAddInterestsModuleInterface> eventHandler;

@end
