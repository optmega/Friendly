//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRRecomendedUserModels,FRRecommendedUsersCellViewModel;


@protocol FRRecommendedUsersDataSourceDelegate <NSObject>

- (void)addUserWithUserModel:(FRRecommendedUsersCellViewModel*)userModel;
- (void)showUserProfile:(NSString*)userId;

@end

@interface FRRecommendedUsersDataSource : NSObject


@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRRecommendedUsersDataSourceDelegate> delegate;

- (void)setupStorageWithModels:(FRRecomendedUserModels*)model;
- (void)reloadData;

@end
