//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenPresenter.h"
#import "FRHomeScreenDataSource.h"
#import "BSHudHelper.h"


@interface FRHomeScreenPresenter () <FRHomeScreenDataSourceDelegate>

@property (nonatomic, strong) FRHomeScreenDataSource* tableDataSource;

@end

@implementation FRHomeScreenPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRHomeScreenDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRHomeScreenViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRHomeScreenHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissHomeScreenController];
}


@end
