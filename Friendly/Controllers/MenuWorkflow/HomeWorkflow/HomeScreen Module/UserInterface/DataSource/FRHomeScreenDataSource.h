//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage;


@protocol FRHomeScreenDataSourceDelegate <NSObject>

@end

@interface FRHomeScreenDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRHomeScreenDataSourceDelegate> delegate;

- (void)setupStorage;

@end
