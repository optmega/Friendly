//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroPresenter.h"
#import "FRIntroDataSource.h"
#import "BSHudHelper.h"
#import "FREventsWireframe.h"


@interface FRIntroPresenter () <FRIntroDataSourceDelegate>

@property (nonatomic, strong) FRIntroDataSource* tableDataSource;

@end

@implementation FRIntroPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRIntroDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRIntroViewInterface>*)userInterface
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

- (void)showHudWithType:(FRIntroHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)loginSuccess:(NSString*)first_login
{
    if ([first_login isEqualToString:@"1"]) {
        [self.wireframe presentLetsGoController];
    }
    else
    {
        [self.wireframe presentHomeScreen];
    }
}

- (void)fbLoginSuccess
{
    self.userInterface.view.hidden = YES;
}
- (void)loginFailure
{
    self.userInterface.view.hidden = NO;
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissIntroController];
}

- (void)loginSelected
{
    [self.interactor login:self.userInterface];
}

@end
