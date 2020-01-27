//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsPresenter.h"
#import "FRFriendRequestsDataSource.h"
#import "BSHudHelper.h"
#import "FRSettingsTransport.h"

@interface FRFriendRequestsPresenter () <FRFriendRequestsDataSourceDelegate>

@property (nonatomic, strong) FRFriendRequestsDataSource* tableDataSource;

@end

@implementation FRFriendRequestsPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRFriendRequestsDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRFriendRequestsViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
//    [self.interactor loadData];
}


#pragma mark - Output

- (void)dataLoadedWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFiends
{
    [self.tableDataSource setupStorageWithFriendRequests:friendRequests potentialFriends:potentialFiends];
}

- (void)showHudWithType:(FRFriendRequestsHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)potentialRequstDone:(FRFriendFamiliarCellViewModel*)model
{
    [self.userInterface removePotentialFriend:model];
}

- (void)friendRequestDone:(FRFriendRequestsCellViewModel*)model
{
    [self.userInterface removeFriendRequest:model];
}

#pragma mark - DataSource

- (void)updateViewWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends
{
    [self.userInterface updateViewWithFriendRequests:friendRequests potentialFriends:potentialFriends];
}

- (void)selectedAdd:(FRFriendFamiliarCellViewModel*)model
{
    [self.interactor addUser:model];
}

- (void)selectedRemove:(FRFriendFamiliarCellViewModel*)model
{
    [self.interactor removeUser:model];
}

- (void)selectedAccept:(FRFriendRequestsCellViewModel*)model
{
    [self.interactor acceptRequst:model];
}

- (void)selectedDecline:(FRFriendRequestsCellViewModel*)model
{
    [self.interactor declineRequest:model];
}

- (void)showUserProfileWithUserId:(NSString*)userId {
    
    [self showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        //
        
        [self showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.wireframe showUserProfileWithEntity:userProfile];
        
    } failure:^(NSError *error) {
        //
        [self showHudWithType:FRFriendRequestsHudTypeError title:@"Error" message:error.localizedDescription];
        
    }];
    
    if (user) {
        [self showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.wireframe showUserProfileWithEntity:user];
    }

}
- (void)showUserProfileWithEntity:(UserEntity*)userT
{
    [self showUserProfileWithUserId:[userT user_id]];
}


#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissFriendRequestsController];
}

- (void)showAddFriends {
    [self.wireframe showAddFriends];
}

- (void)viewWillApear {
    [self.interactor loadData];
}

@end
