//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsPresenter.h"
#import "FRAddInterestsDataSource.h"
#import "BSHudHelper.h"


@interface FRAddInterestsPresenter () <FRAddInterestsDataSourceDelegate>

@property (nonatomic, strong) FRAddInterestsDataSource* tableDataSource;

@end

@implementation FRAddInterestsPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRAddInterestsDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRAddInterestsViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}


- (void)selectedInterest:(FRInterestsModel*)interest
{
    [self.interactor selectetInterest:interest];
}


#pragma mark - Output

- (void)dataLoadedWithModel:(FRInterestsModels*)model
{
    [self.tableDataSource setupStorageWithModel:model];
}

- (void)showHudWithType:(FRAddInterestsHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)goNextWithInterests:(NSArray *)interests
{
    [self.userInterface showHiddenAnimationWithComplete:^{
        [self.wireframe presentRecommendedUsersControllerWithInterests:interests];
    }];
}

- (void)goNextWithUsers:(FRRecomendedUserModels*)users interests:(NSArray*)interests {
    [self.wireframe presentRecommendedUsersControllerUsers:users interests:interests];
}

- (void)goProfileSettingsWithInterests:(NSArray*)interests {
    [self.wireframe presentSettingsWithInterests:interests];
}

- (void)addedInterests:(FRInterestsModel*)interest
{
    [self.tableDataSource addInterests:interest];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissAddInterestsController];
}

- (void)continueSelected
{
    [self.interactor selectedContinue];
}

- (void)addTagSelected:(NSString *)tag
{
    [self.interactor addTag:tag];
}

@end
