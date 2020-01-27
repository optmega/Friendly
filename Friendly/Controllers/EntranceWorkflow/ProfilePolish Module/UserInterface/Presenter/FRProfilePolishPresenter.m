//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishPresenter.h"
#import "FRProfilePolishDataSource.h"
#import "BSHudHelper.h"


@interface FRProfilePolishPresenter () <FRProfilePolishDataSourceDelegate>

@property (nonatomic, strong) FRProfilePolishDataSource* tableDataSource;

@end

@implementation FRProfilePolishPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRProfilePolishDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRProfilePolishViewInterface>*)userInterface interests:(NSArray*)interests
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadDataWithInterests:interests];
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRProfilePolishHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)profileUpdated
{
    [self.wireframe presentHomeScreen];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.userInterface showHiddenAnimationWithComplete:^{
        [self.wireframe dismissProfilePolishController];        
    }];
}

- (void)finishSelected
{
    [self.interactor updateUserProfile:[self.tableDataSource profile]];
}


#pragma mark - FRPhotoPickerControllerDelegate

- (void)imageSelected:(UIImage*)image
{
    [self.tableDataSource updateUserPhoto:image];
}


#pragma mark - DataSource delegate

- (void)emptyEventField:(NSString *)string
{
    [BSHudHelper showHudWithType:BSHudTypeError view:self.userInterface title:@"You need to fill in the following fields first:" message:string];
}

- (void)selectedChangePhoto
{
    [self.wireframe presentPhotoPickerController];
}

- (void)selectedConnectInstagram
{
    [self.wireframe presentInstagramAuthController];
}

@end
