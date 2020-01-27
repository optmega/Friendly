//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRHomeScreenDataSource;

@protocol FRHomeScreenViewInterface <NSObject>

- (void)updateDataSource:(FRHomeScreenDataSource*)dataSource;

@end
