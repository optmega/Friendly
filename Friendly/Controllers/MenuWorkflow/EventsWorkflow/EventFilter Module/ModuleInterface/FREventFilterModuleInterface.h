//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@protocol FREventFilterModuleInterface <NSObject>

- (void)backSelected;
- (void)doneSelected;
- (void)dateSelected;
- (void)genderSelected;
- (void)locationSelected;

@end
