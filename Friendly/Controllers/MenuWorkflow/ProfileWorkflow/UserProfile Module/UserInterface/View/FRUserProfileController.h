//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRUserProfileDataSource;


@interface FRUserProfileController : BSTableController

- (void)updateDataSource:(FRUserProfileDataSource*)dataSource;

@end
