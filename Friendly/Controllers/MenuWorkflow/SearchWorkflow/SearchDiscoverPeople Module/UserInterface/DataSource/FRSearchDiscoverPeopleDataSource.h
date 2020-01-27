//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRSearchUsers;


@protocol FRSearchDiscoverPeopleDataSourceDelegate <NSObject>

- (void)profileSelectedWithUserId:(NSString*)userId;
- (void)addSelectedWithUserId:(NSString*)userId;
- (void)friendsSelectedWithUserId:(NSString*)userId;


@end

@interface FRSearchDiscoverPeopleDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRSearchDiscoverPeopleDataSourceDelegate> delegate;

- (void)setupStorage;
- (void)updateStorageWithUsers:(FRSearchUsers*)users;

@end
