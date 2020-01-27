//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeoplePresenter.h"
#import "FRSearchDiscoverPeopleDataSource.h"
#import "BSHudHelper.h"
#import "FRFriendsTransport.h"
#import "FRSettingsTransport.h"

@interface FRSearchDiscoverPeoplePresenter () <FRSearchDiscoverPeopleDataSourceDelegate>

@property (nonatomic, strong) FRSearchDiscoverPeopleDataSource* tableDataSource;

@end

@implementation FRSearchDiscoverPeoplePresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRSearchDiscoverPeopleDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRSearchDiscoverPeopleViewInterface>*)userInterface tag:(NSString*)tag
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.userInterface updateSaerchBarText:tag];
    [self.interactor loadUsersForString:tag];
    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRSearchDiscoverPeopleHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)usersLoaded:(FRSearchUsers*)users
{
    [self.tableDataSource updateStorageWithUsers:users];
}

- (void)profileSelectedWithUserId:(NSString*)userId
{
    [self showHudWithType:FRSearchDiscoverPeopleHudTypeShowHud title:nil message:nil];
    UserEntity* user =  [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        
        [self showHudWithType:FRSearchDiscoverPeopleHudTypeHideHud title:nil message:nil];

        [self.wireframe presentUserProfile:userProfile];
    } failure:^(NSError *error) {
        [self showHudWithType:FRSearchDiscoverPeopleHudTypeError title:@"Error" message:error.localizedDescription];

    }];
    
    if (user) {
        [self showHudWithType:FRSearchDiscoverPeopleHudTypeHideHud title:nil message:nil];
        [self.wireframe presentUserProfile:user];
    }
}

- (void)addSelectedWithUserId:(NSString*)userId
{
    [FRFriendsTransport inviteFriendsWithId:userId message:@"" success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}
- (void)friendsSelectedWithUserId:(NSString*)userId
{
    
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissSearchDiscoverPeopleController];
}

- (void)searchBar:(NSString*)text
{
    [self.interactor loadUsersForString:text];
}

@end
