//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FREditProfileDataSource;


@interface FREditProfileController : BSTableController

- (void)updateDataSource:(FREditProfileDataSource*)dataSource;

@end
