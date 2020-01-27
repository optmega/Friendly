//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfilePresenter.h"
#import "FREditProfileDataSource.h"
#import "BSHudHelper.h"


@interface FREditProfilePresenter () <FREditProfileDataSourceDelegate>

@property (nonatomic, strong) FREditProfileDataSource* tableDataSource;
@property (nonatomic, strong) UserEntity* userModel;

@end

@implementation FREditProfilePresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FREditProfileDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FREditProfileViewInterface>*)userInterface userModel:(UserEntity *)userModel
{
    self.userModel = userModel;
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}

- (void)updatePhoto:(UIImage*)photo type:(FRChangePhotoType)type
{
    switch (type) {
        case FRChangePhotoTypeWall:
        {
            [self.tableDataSource updateWallPhoto:photo];
        }break;
        case FRChangePhotoTypeUserPhoto:
        {
            [self.tableDataSource updateUserPhoto:photo];
        }break;
    }
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorageWithUserModel:self.userModel];
}

- (void)showHudWithType:(FREditProfileHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)profileUpdated
{
    [self.wireframe dismissEditProfileController];
//    [self.tableDataSource updateUserPhoto:[FRUserManager sharedInstance].currentUserPhoto];
}

#pragma mark - DataSource delegate

- (void)updateWallImage:(UIImage*)image
{
    [self.userInterface updateWallImage:image];
}

- (void)updateWallImageUrl:(NSString*)imageUrl
{
    [self.userInterface updateWallImageUrl:imageUrl];
}

- (void)emptyEventField:(NSString*)message
{
    if ([message isEqualToString:@"Interests"]) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self.userInterface title:@"Oops" message:@"You need to write at least three interests"];
    }
    else
    {
        [BSHudHelper showHudWithType:BSHudTypeError view:self.userInterface title:@"You need to fill in the following fields first:" message:message];
    }
}

- (void)changeUserPhoto
{
    [self.wireframe presentPhotoPickerControllerWithType:FRChangePhotoTypeUserPhoto];
}

- (void)changeWallPhoto
{
    [self.wireframe presentPhotoPickerControllerWithType:FRChangePhotoTypeWall];
}

- (void)saveSelected
{
    [self.interactor updateUserProfile:[self.tableDataSource profile]];
}

- (void)settingSelected
{
    [self.wireframe presentSettingController];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissEditProfileController];
}



@end
