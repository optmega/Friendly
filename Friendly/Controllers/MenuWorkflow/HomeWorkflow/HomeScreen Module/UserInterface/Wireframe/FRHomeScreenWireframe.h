//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRHomeScreenWireframe : NSObject

- (void)presentHomeScreenControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissHomeScreenController;

@end
