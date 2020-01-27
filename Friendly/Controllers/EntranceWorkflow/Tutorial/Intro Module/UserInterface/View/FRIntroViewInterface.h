//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRIntroDataSource;

@protocol FRIntroViewInterface <NSObject>

- (void)updateDataSource:(FRIntroDataSource*)dataSource;

@end
