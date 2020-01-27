//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRSearchDiscoverPeopleDataSource;


@interface FRSearchDiscoverPeopleController : BSTableController

- (void)updateDataSource:(FRSearchDiscoverPeopleDataSource*)dataSource;

@end
