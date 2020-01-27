//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingPresenter.h"
#import "FRSettingDataSource.h"
#import "BSHudHelper.h"


@interface FRSettingPresenter () <FRSettingDataSourceDelegate>

@property (nonatomic, strong) FRSettingDataSource* tableDataSource;

@end

@implementation FRSettingPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRSettingDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRSettingViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoaded:(Setting *)model
{
    [self.tableDataSource setupStorage:model];
}

- (void)showHudWithType:(FRSettingHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)logOuted
{
    [self.wireframe globalDissmiss];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.interactor saveSetting:[self.tableDataSource settingsDomainModel]];
    [self.wireframe dismissSettingController];
}

- (void)logOutSelected
{
    [self.interactor saveSetting:[self.tableDataSource settingsDomainModel]];
    [self.interactor logOut];
}

@end
