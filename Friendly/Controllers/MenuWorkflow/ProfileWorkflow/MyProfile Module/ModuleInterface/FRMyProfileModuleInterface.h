//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@protocol FRMyProfileModuleInterface <NSObject>

- (void)backSelected;
- (void)updateData;
- (void)saveEditSelected;
- (void)loadData;
- (void) reloadInstagram;

@end
