//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileViewInterface.h"
#import "FREditProfileModuleInterface.h"
#import "FRBaseVC.h"

@interface FREditProfileVC : FRBaseVC <FREditProfileViewInterface>

@property (nonatomic, strong) id<FREditProfileModuleInterface> eventHandler;

@end
