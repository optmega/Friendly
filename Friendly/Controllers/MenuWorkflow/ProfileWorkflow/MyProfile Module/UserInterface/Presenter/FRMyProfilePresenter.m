//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfilePresenter.h"
#import "FRMyProfileDataSource.h"
#import "BSHudHelper.h"


@interface FRMyProfilePresenter () <FRMyProfileDataSourceDelegate>

@property (nonatomic, strong) FRMyProfileDataSource* tableDataSource;
@property (nonatomic, strong) UserEntity* userModel;
@property (nonatomic, strong) NSArray* users;

@end

@implementation FRMyProfilePresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRMyProfileDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRMyProfileViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.tableDataSource setupStorage];
    
//    BSDispatchBlockToBackgroundQueue(^{
    
        [self.interactor loadData];
//    });
}


#pragma mark - Output

- (void)dataLoadedWithModel:(CurrentUser *)userModel andUsers:(NSArray*)friends
{
    self.userModel = userModel;
    [self.tableDataSource updateStorage:userModel andUsers:friends];
}

- (void)showHudWithType:(FRMyProfileHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)updateDataWithModel:(CurrentUser*)userModel
{
    self.userModel = userModel;
    [self.tableDataSource updateStorage:userModel andUsers:self.users];
}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissMyProfileController];
}

- (void)updateData
{
    [self.interactor updateData];
}

- (void)loadData
{
    [self.interactor loadData];
}

#pragma mark - FRMyProfileDataSourceDelegate

- (void)updateWallImage:(NSString*)imageUrl
{
    [self.userInterface updateWallImage:imageUrl];
}

- (void)saveEditSelected
{
    [self.wireframe presentEditProfile:self.userModel];
}

- (void)settingSelected
{
    [self.wireframe presentSettingController];
}

- (void)statusSelected
{
    [self.wireframe presentStatusInputController];
}

- (void)selectedStatus:(NSString*)status
{
    [self.tableDataSource updateUserStatusStatus:status];
}

- (void)connectInstagramSelected
{
    [self.wireframe presentInstagramAuthController];
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.wireframe presentPreviewControllerWithImage:image];
}

- (void)showUserProfile:(NSString*)userId
{
    [self.wireframe showUserProfile:userId];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.wireframe showUserProfileWithEntity:user];
}

- (void)changeStatus:(NSInteger)status {
    [self.interactor changeStatus: status];
}

- (void)presentAddMobileController
{
    [self.wireframe presentAddMobileController];
}

- (void)presentInviteFriendsController
{
    [self.wireframe presentInviteFriendsController];
}

- (void)reloadInstagram
{
//    id item = [self.tableDataSource.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    [self.tableDataSource.storage reloadItem:[self.tableDataSource.storage itemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]]];
    [self.interactor loadData];
}

 

@end
