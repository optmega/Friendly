//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRSettingDataSource;

@protocol FRSettingViewInterface <NSObject>

- (void)updateDataSource:(FRSettingDataSource*)dataSource;

@end
