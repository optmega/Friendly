//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerViewInterface.h"
#import "FRMessagerModuleInterface.h"
#import "FRBaseVC.h"

@interface FRMessagerVC : FRBaseVC <FRMessagerViewInterface>

@property (nonatomic, strong) id<FRMessagerModuleInterface> eventHandler;

@end
