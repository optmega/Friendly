//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"
#import "FREventFilterViewConstatns.h"

@class FREventFilterDataSource;


@protocol FREventFilterControllerDelegate <NSObject>

- (void)selectedCell:(FREventFilterCellType)type;

@end


@interface FREventFilterController : BSTableController

@property (nonatomic, weak) id<FREventFilterControllerDelegate> delegate;

- (void)updateDataSource:(FREventFilterDataSource*)dataSource;

@end
