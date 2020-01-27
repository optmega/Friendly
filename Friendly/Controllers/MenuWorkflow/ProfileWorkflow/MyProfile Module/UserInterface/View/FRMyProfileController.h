//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRMyProfileDataSource;


@interface FRMyProfileController : BSTableController

- (void)updateDataSource:(FRMyProfileDataSource*)dataSource;

@end
