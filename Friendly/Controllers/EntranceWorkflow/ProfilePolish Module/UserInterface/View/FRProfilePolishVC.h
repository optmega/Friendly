//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishViewInterface.h"
#import "FRProfilePolishModuleInterface.h"
#import "FRBaseVC.h"

@interface FRProfilePolishVC : FRBaseVC <FRProfilePolishViewInterface>

@property (nonatomic, strong) id<FRProfilePolishModuleInterface> eventHandler;

@end
