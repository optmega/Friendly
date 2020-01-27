//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FREventsDataSource, FREventModel;

@protocol FREventsControllerDelegate <NSObject>

- (void)showShowUserProfileSelected;
- (void)showFilter;

- (void)selectingCell:(CGRect)attributes image:(UIImage*)image event:(FREventModel*)event firstCell:(BOOL)firstCell;
- (void)updateHeaderViewForPosition:(CGFloat)positionY opacity:(CGFloat)opacity;


@end


@interface FREventsController : BSTableController

@property (nonatomic, weak) id<FREventsControllerDelegate> delegate;

- (void)updateDataSource:(FREventsDataSource*)dataSource;

@end
