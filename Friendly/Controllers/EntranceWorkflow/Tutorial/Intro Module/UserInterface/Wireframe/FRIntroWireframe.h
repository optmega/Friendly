//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//
#import "FRIntroVC.h"

@interface FRIntroWireframe : NSObject

@property (nonatomic, weak) FRIntroVC* introController;

- (void)presentIntroControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissIntroController;
- (void)presentLetsGoController;
- (void)presentHomeScreen;

@end
