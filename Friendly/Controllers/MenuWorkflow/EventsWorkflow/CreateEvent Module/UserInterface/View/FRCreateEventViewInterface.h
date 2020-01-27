//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRCreateEventDataSource;

typedef NS_ENUM(NSInteger, FRCreateEventType) {
    FRCreateEventCreate,
    FRCreateEventEdit,
};


@protocol FRCreateEventViewInterface <NSObject>

- (void)updateDataSource:(FRCreateEventDataSource*)dataSource;
- (void)updateWithType:(FRCreateEventType)type;

@end
