//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerPresenter.h"
#import "FRMessagerDataSource.h"
#import "BSHudHelper.h"
#import "FRSettingsTransport.h"
#import "FRPrivateRoom.h"

@interface FRMessagerPresenter () <FRMessagerDataSourceDelegate>

@property (nonatomic, strong) FRMessagerDataSource* tableDataSource;

@end

@implementation FRMessagerPresenter

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.tableDataSource = [FRMessagerDataSource new];
        self.tableDataSource.delegate = self;
    }
    return self;
}

- (void)configurePresenterWithUserInterface:(UIViewController<FRMessagerViewInterface>*)userInterface
{
    self.userInterface = userInterface;
    [self.userInterface updateDataSource:self.tableDataSource];
    [self.interactor loadData];
}

- (void)showAddUser {
    [self.wireframe showAddUser];
}

- (void)selectedChatForRoom:(FRPrivateRoom*)room
{
    
    [self.wireframe presentPrivateChatWithUser:room.opponent];
    
    return;
}

- (void)selectedGroupRoom:(FRGroupRoom*)room
{
    [self.wireframe presentGroupChat:room];
}

#pragma mark - Output

- (void)dataLoaded
{
    [self.tableDataSource setupStorage];
}

- (void)showHudWithType:(FRMessagerHudType)type title:(NSString*)title message:(NSString*)message
{
    [BSHudHelper showHudWithType:(BSHudType)type view:self.userInterface title:title message:message];
}

- (void)updateChats {
        
    [self.userInterface updateChats];
}

- (void)searchText:(NSString*)searchText {
    [self.interactor searchRoomForTitle:searchText];
}

//- (void)updateChats {
//    [self.interactor loadChats];
//}

#pragma mark - Module Interface

- (void)backSelected
{
    [self.wireframe dismissMessagerController];
}

- (void)showFriendRequest {
    [self.wireframe presentFriendRequest];
}

- (void)selectedUser:(UserEntity*)user {
//    [self.wireframe presentUserProfile:user];
    [self.wireframe presentPrivateChatWithUser:user];
}

- (void)showSearch {
    [self.wireframe showSearchController];
}

- (void)updateChatRoomsWithCount:(NSInteger)countRooms {
    [self.interactor updateChatRoomsWithCount:countRooms];
}

- (void)updateAvailableFriends:(NSInteger)count {
    [self.interactor updateAvailableFriends:count];
}

@end
