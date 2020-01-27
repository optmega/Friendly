//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingDataSource.h"
#import "BSMemoryStorage.h"
#import "FRPrivateAccountCellViewModel.h"
#import "FRSupportCellViewModel.h"
#import "FRLogOutCellViewModel.h"
#import "FRDisplayNameCellViewModel.h"
#import "FRUserManager.h"
#import "FRSettingModel.h"
#import "FRSettingDomainModel.h"

@implementation FRSettingDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage1:(Setting*)model
{
    [self.storage removeAllItems];
    
    NSString* notificationTitleModel = FRLocalizedString(@"NOTIFICATIONS", nil);
    [self.storage addItem:notificationTitleModel];
    
    FRPrivateAccountCellViewModel* eventRequestModel = [FRPrivateAccountCellViewModel new];
    eventRequestModel.title = FRLocalizedString(@"Event requests", nil);
    eventRequestModel.subtitle = FRLocalizedString(@"Users asking to join your events", nil);
    eventRequestModel.isPrivateAccount = model.eventRequests.boolValue;
    [self.storage addItem:eventRequestModel];
    
    
    FRPrivateAccountCellViewModel* friendRequestsModel = [FRPrivateAccountCellViewModel new];
    friendRequestsModel.title = FRLocalizedString(@"Friend requests", nil);
    friendRequestsModel.subtitle = FRLocalizedString(@"Users asking to be added to your friends list", nil);
    friendRequestsModel.isPrivateAccount = model.friendRequests.boolValue;
    [self.storage addItem:friendRequestsModel];
    
    
    FRPrivateAccountCellViewModel* eventInviteModel = [FRPrivateAccountCellViewModel new];
    eventInviteModel.title = FRLocalizedString(@"Event Invites", nil);
    eventInviteModel.subtitle = FRLocalizedString(@"Users inviting you to their events", nil);
    eventInviteModel.isPrivateAccount = model.eventInvites.boolValue;
    [self.storage addItem:eventInviteModel];
    
    FRPrivateAccountCellViewModel* groupChatMessagesModel = [FRPrivateAccountCellViewModel new];
    groupChatMessagesModel.title = FRLocalizedString(@"Group chat messages", nil);
    groupChatMessagesModel.subtitle = FRLocalizedString(@"A group chat message from an event your in", nil);
    groupChatMessagesModel.isFullSeparator = YES;
    groupChatMessagesModel.isPrivateAccount = model.groupMessagesNotification.boolValue;
    [self.storage addItem:groupChatMessagesModel];
    
    NSString* accountTitleModel = FRLocalizedString(@"ACCOUNT", nil);
    [self.storage addItem:accountTitleModel];
    
    FRPrivateAccountCellViewModel* privateAccountModel = [FRPrivateAccountCellViewModel new];
//    privateAccountModel.title = FRLocalizedString(@"Private account", nil);
//    privateAccountModel.subtitle = FRLocalizedString(@"Hidden images & only friends can message", nil);
//    privateAccountModel.isPrivateAccount = model.privateAccount.boolValue;
    [self.storage addItem:privateAccountModel];
    
    FRDisplayNameCellViewModel* displayNameModel = [FRDisplayNameCellViewModel new];
    displayNameModel.title = FRLocalizedString(@"Display name", nil);
//    displayNameModel.subtitle = FRLocalizedString(@"What all other users see", nil);
    displayNameModel.content = model.firstName;
    [self.storage addItem:displayNameModel];
    
    FRSupportCellViewModel* supportModel = [FRSupportCellViewModel new];
    supportModel.title = FRLocalizedString(@"Support", nil);
    supportModel.subtitle = FRLocalizedString(@"support@joinfriendly.com", nil);
    [self.storage addItem:supportModel];

    FRLogOutCellViewModel* logOutModel = [FRLogOutCellViewModel new];
    logOutModel.title = FRLocalizedString(@"Log out", nil);
    logOutModel.subtitle = FRLocalizedString(@"Disconnect this account", nil);
    [self.storage addItem:logOutModel];
    
}

///*

- (void)setupStorage:(Setting*)model
 {
     
     NSString* notificationTitleModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        if (!notificationTitleModel) {
            notificationTitleModel = FRLocalizedString(@"NOTIFICATIONS", nil);
            [self.storage addItem:notificationTitleModel];
     }
 
     FRPrivateAccountCellViewModel* eventRequestModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
     if (!eventRequestModel) {
 
         eventRequestModel = [FRPrivateAccountCellViewModel new];
         eventRequestModel.title = FRLocalizedString(@"Event requests", nil);
         eventRequestModel.subtitle = FRLocalizedString(@"Users asking to join your events", nil);
         [self.storage addItem:eventRequestModel];
     }
    eventRequestModel.isPrivateAccount = model.eventRequests.boolValue;
    [self.storage reloadItem:eventRequestModel];
     
     
     FRPrivateAccountCellViewModel* friendRequestsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
     if (!friendRequestsModel) {
     
         friendRequestsModel = [FRPrivateAccountCellViewModel new];
         friendRequestsModel.title = FRLocalizedString(@"Friend requests", nil);
         friendRequestsModel.subtitle = FRLocalizedString(@"Users asking to be added to your friends list", nil);
         [self.storage addItem:friendRequestsModel];
     }
    friendRequestsModel.isPrivateAccount = model.friendRequests.boolValue;
     [self.storage reloadItem:friendRequestsModel];
     
     
     FRPrivateAccountCellViewModel* eventInviteModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
     if (!eventInviteModel) {
     
         eventInviteModel = [FRPrivateAccountCellViewModel new];
         eventInviteModel.title = FRLocalizedString(@"Event Invites", nil);
         eventInviteModel.subtitle = FRLocalizedString(@"Users inviting you to their events", nil);
         [self.storage addItem:eventInviteModel];
     }
     eventInviteModel.isPrivateAccount = model.eventInvites.boolValue;
     [self.storage reloadItem:eventInviteModel];
     
     
     FRPrivateAccountCellViewModel* groupChatMessagesModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
     if (!groupChatMessagesModel) {
     
         groupChatMessagesModel = [FRPrivateAccountCellViewModel new];
         groupChatMessagesModel.title = FRLocalizedString(@"Group chat messages", nil);
         groupChatMessagesModel.subtitle = FRLocalizedString(@"A group chat message from an event your in", nil);
         groupChatMessagesModel.isFullSeparator = YES;
         [self.storage addItem:groupChatMessagesModel];
     }
     groupChatMessagesModel.isPrivateAccount = model.groupMessagesNotification.boolValue;
     [self.storage reloadItem:groupChatMessagesModel];
     
     
     NSString* accountTitleModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:5 inSection:0]];
     if (!accountTitleModel) {
     
         accountTitleModel = FRLocalizedString(@"ACCOUNT", nil);
         [self.storage addItem:accountTitleModel];
     }
     
     FRPrivateAccountCellViewModel* privateAccountModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
     if (!privateAccountModel) {
     
         privateAccountModel = [FRPrivateAccountCellViewModel new];
//         privateAccountModel.title = FRLocalizedString(@"Private account", nil);
//         privateAccountModel.subtitle = FRLocalizedString(@"Hidden images & only friends can message", nil);
         [self.storage addItem:privateAccountModel];
    }
     privateAccountModel.isPrivateAccount = model.privateAccount.boolValue;
     [self.storage reloadItem:privateAccountModel];
     
     
     FRDisplayNameCellViewModel* displayNameModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
     if (!displayNameModel) {
     
         displayNameModel = [FRDisplayNameCellViewModel new];
         displayNameModel.title = FRLocalizedString(@"Display name", nil);
     //    displayNameModel.subtitle = FRLocalizedString(@"What all other users see", nil);
         [self.storage addItem:displayNameModel];
     }
     displayNameModel.content = model.firstName;
     [self.storage reloadItem:displayNameModel];
     
     
     FRSupportCellViewModel* supportModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:8 inSection:0]];
     if (!supportModel) {
     
         supportModel = [FRSupportCellViewModel new];
         supportModel.title = FRLocalizedString(@"Support", nil);
         supportModel.subtitle = FRLocalizedString(@"support@joinfriendly.com", nil);
        [self.storage addItem:supportModel];
     }
     
     FRLogOutCellViewModel* logOutModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:9 inSection:0]];
     if (!logOutModel) {
     
         logOutModel = [FRLogOutCellViewModel new];
         logOutModel.title = FRLocalizedString(@"Log out", nil);
         logOutModel.subtitle = FRLocalizedString(@"Disconnect this account", nil);
         [self.storage addItem:logOutModel];
     }
 
 }
 //*/

- (FRSettingDomainModel*)settingsDomainModel
{
 
    FRSettingDomainModel* domainModel = [FRSettingDomainModel new];
 
    FRPrivateAccountCellViewModel* eventRequestModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    domainModel.event_requests = eventRequestModel.isPrivateAccount;
 
    FRPrivateAccountCellViewModel* friendRequestsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    domainModel.friend_requests = friendRequestsModel.isPrivateAccount;
    
    FRPrivateAccountCellViewModel* eventInviteModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
    domainModel.event_invites = eventInviteModel.isPrivateAccount;
    
    FRPrivateAccountCellViewModel* groupChatMessagesModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]];
    domainModel.group_chat_messages = groupChatMessagesModel.isPrivateAccount;
    
    FRPrivateAccountCellViewModel* privateAccountModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:6 inSection:0]];
    domainModel.private_account = privateAccountModel.isPrivateAccount;
    
    FRDisplayNameCellViewModel* displayNameModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:7 inSection:0]];
//    domainModel.user_name = displayNameModel.content;
    
    return domainModel;

}

#pragma mark - Private



@end
