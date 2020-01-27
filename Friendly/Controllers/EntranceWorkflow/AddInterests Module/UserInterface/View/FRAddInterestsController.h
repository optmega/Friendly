//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRAddInterestsDataSource;

@protocol BSTableControllerScrollDelegate <NSObject>

- (void)tableScrollViewDidScroll:(UIScrollView*)scrollView;

@end

@interface FRAddInterestsController : BSTableController

@property (nonatomic, weak) id<BSTableControllerScrollDelegate> interestsScrollDeletage;

- (void)updateDataSource:(FRAddInterestsDataSource*)dataSource;

@end
