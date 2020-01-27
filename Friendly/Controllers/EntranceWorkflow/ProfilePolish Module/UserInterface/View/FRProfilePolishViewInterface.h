//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRProfilePolishDataSource;

@protocol FRProfilePolishViewInterface <NSObject>

- (void)updateDataSource:(FRProfilePolishDataSource*)dataSource;
- (void)showHiddenAnimationWithComplete:(void(^)())complete;

@end
