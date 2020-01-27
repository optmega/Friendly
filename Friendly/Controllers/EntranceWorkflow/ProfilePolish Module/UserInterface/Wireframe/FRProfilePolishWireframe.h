//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRProfilePolishWireframe : NSObject

- (void)presentProfilePolishControllerFromNavigationController:(UINavigationController*)nc interests:(NSArray*)interests;
- (void)dismissProfilePolishController;
- (void)presentHomeScreen;
- (void)presentPhotoPickerController;
- (void)presentInstagramAuthController;

@end
