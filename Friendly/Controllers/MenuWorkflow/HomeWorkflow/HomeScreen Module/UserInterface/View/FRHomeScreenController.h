//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRHomeScreenDataSource;


@interface FRHomeScreenController : BSTableController

- (void)updateDataSource:(FRHomeScreenDataSource*)dataSource;

@end
