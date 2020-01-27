//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRRecomendedUserModels, FRRecommendedUsersCellViewModel;

typedef NS_ENUM(NSInteger, FRRecommendedUsersHudType) {
    FRRecommendedUsersHudTypeError,
    FRRecommendedUsersHudTypeShowHud,
    FRRecommendedUsersHudTypeHideHud,
};

@protocol FRRecommendedUsersInteractorInput <NSObject>

- (void)loadData:(FRRecomendedUserModels*)users;
- (void)addUserWithUserModel:(FRRecommendedUsersCellViewModel*)userModel;

@end


@protocol FRRecommendedUsersInteractorOutput <NSObject>

- (void)dataLoadedWithModel:(FRRecomendedUserModels*)models;
- (void)showHudWithType:(FRRecommendedUsersHudType)type title:(NSString*)title message:(NSString*)message;
- (void)reloadData;

@end