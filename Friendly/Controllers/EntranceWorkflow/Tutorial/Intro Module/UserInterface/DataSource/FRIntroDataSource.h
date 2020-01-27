//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage;


@protocol FRIntroDataSourceDelegate <NSObject>

@end

@interface FRIntroDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRIntroDataSourceDelegate> delegate;

- (void)setupStorage;

@end
