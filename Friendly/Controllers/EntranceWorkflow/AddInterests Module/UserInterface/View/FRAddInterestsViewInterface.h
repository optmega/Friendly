//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRAddInterestsDataSource;

@protocol FRAddInterestsViewInterface <NSObject>

- (void)updateDataSource:(FRAddInterestsDataSource*)dataSource;
- (void)showHiddenAnimationWithComplete:(void(^)())complete;
@end
