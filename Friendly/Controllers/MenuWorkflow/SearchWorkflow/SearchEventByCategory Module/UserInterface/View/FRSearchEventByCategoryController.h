//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRSearchEventByCategoryDataSource, FREventModel;

@protocol FRSearchEventByCategoryControllerDelegate <NSObject>

- (void)selectedDiscoverPeople;
- (void)selectedEvent:(FREvent*)event;

@end

@interface FRSearchEventByCategoryController : BSTableController

@property (nonatomic, weak) id<FRSearchEventByCategoryControllerDelegate> delegate;

- (void)updateDataSource:(FRSearchEventByCategoryDataSource*)dataSource;

@end
