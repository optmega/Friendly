//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRSettingDataSource;

@protocol FRSettingControllerDelegate <NSObject>

- (void)logOut;

@end

@interface FRSettingController : BSTableController

@property (nonatomic, weak) id<FRSettingControllerDelegate> delegate;
- (void)updateDataSource:(FRSettingDataSource*)dataSource;

@end
