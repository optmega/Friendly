//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FREventFilterWireframe : NSObject

- (void)presentEventFilterControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissEventFilterController;
- (void)presentGenderVCWithGenderType:(FRGenderType)type;
- (void)presentDateVCWithDateType;
- (void)presentLocationVC;

@end
