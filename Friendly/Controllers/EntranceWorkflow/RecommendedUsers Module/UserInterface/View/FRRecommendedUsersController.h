//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRRecommendedUsersDataSource;

@protocol BSTableControllerScrollDelegate <NSObject>

- (void)backSelected;

@end

@interface FRRecommendedUsersController : BSTableController

@property (nonatomic, weak) id<BSTableControllerScrollDelegate> recommendedScrollDeletage;
- (void)updateDataSource:(FRRecommendedUsersDataSource*)dataSource;

@end
