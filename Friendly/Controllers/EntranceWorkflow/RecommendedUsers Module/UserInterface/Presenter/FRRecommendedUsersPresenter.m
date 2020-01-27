//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersPresenter.h"
#import "FRRecommendedUsersDataSource.h"
#import "BSHudHelper.h"


@interface FRRecommendedUsersPresenter () <FRRecommendedUsersDataSourceDelegate>

@property (nonatomic, strong) FRRecommendedUsersDataSource* tableDataSource;

@end

@implementation FRRecommendedUsersPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRRecommendedUsersDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRRecommendedUsersViewInterface>*)userInterface users:(FRRecomendedUserModels*)users
{
    self.userInterface = userInterface;

    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData:users];
}


#pragma mark - Output

- (void)dataLoadedWithModel:(FRRecomendedUserModels *)models
{
    [self.tableDataSource setupStorageWithModels:models];
}

- (void)showHudWithType:(FRRecommendedUsersHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)reloadData
{
    [self.tableDataSource reloadData];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.userInterface showHiddenAnimationWithComplete:^{
        [self.wireframe dismissRecommendedUsersController];
    }];
}

- (void)skipSelected
{
    [self.wireframe presentHomeScreenController];
}

- (void)continueSelected
{
    [self.userInterface showHiddenAnimationWithComplete:^{
        [self.wireframe presentProfilePolish];
    }];
}


#pragma mark - FRRecommendedUsersDataSourceDelegate

- (void)addUserWithUserModel:(FRRecommendedUsersCellViewModel*)userModel
{
    [self.interactor addUserWithUserModel:userModel];
}

- (void)showUserProfile:(NSString*)userId
{
    [self.wireframe showUserProfileWithId:userId];
}

@end
