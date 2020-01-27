//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRIntroDataSource;


@interface FRIntroController : BSTableController

- (void)updateDataSource:(FRIntroDataSource*)dataSource;

@end
