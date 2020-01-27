//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage;


@protocol FRFriendsEventsDataSourceDelegate <NSObject>

@end

@interface FRFriendsEventsDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRFriendsEventsDataSourceDelegate> delegate;

- (void)setupStorage;

@end
