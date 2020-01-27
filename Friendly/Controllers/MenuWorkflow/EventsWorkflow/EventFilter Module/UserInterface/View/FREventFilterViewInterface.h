//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventFilterDataSource;

@protocol FREventFilterViewInterface <NSObject>

- (void)updateDataSource:(FREventFilterDataSource*)dataSource;

@end
