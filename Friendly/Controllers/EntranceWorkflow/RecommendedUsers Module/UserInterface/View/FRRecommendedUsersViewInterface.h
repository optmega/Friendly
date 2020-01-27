//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRRecommendedUsersDataSource;

@protocol FRRecommendedUsersViewInterface <NSObject>

- (void)updateDataSource:(FRRecommendedUsersDataSource*)dataSource;
- (void)showHiddenAnimationWithComplete:(void(^)())complete;
@end
