//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsInteractor.h"
#import "FRFriendsTransport.h"
#import "FRFriendsListModel.h"
#import "FRFriendFamiliarCellViewModel.h"
#import "FRFriendRequestsCellViewModel.h"
#import "FRSettingsTransport.h"

@implementation FRFriendRequestsInteractor

- (void)loadData
{
    [self.output showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    [FRFriendsTransport getFriendlyRequestsWithSuccess:^(FRFriendlyRequestsModel *requests) {
        [self.output showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        
        [self.output dataLoadedWithFriendRequests:requests.friendly_requests potentialFriends:requests.people_you_may_know];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRFriendRequestsHudTypeError title:@"Error" message:error.localizedDescription];
    }];
    
}


- (void)addUser:(FRFriendFamiliarCellViewModel*)model
{
    [self.output showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    [FRFriendsTransport inviteFriendsWithId:model.userId message:@"" success:^{
        [self.output showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.output potentialRequstDone:model];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRFriendRequestsHudTypeError title:FRLocalizedString(@"Error", nil)  message:error.localizedDescription];
    }];
}

- (void)removeUser:(FRFriendFamiliarCellViewModel*)model
{
    [self.output showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    [FRFriendsTransport removeUserFromPotentialFriendWithUserId:model.userId success:^{
        [self.output showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.output potentialRequstDone:model];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRFriendRequestsHudTypeError title:FRLocalizedString(@"Error", nil)  message:error.localizedDescription];
    }];
    
}

- (void)acceptRequst:(FRFriendRequestsCellViewModel*)model
{
    [self.output showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    [FRFriendsTransport acceptRequestId:model.requestId success:^{
        
        [self.output showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.output friendRequestDone:model];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRFriendRequestsHudTypeError title:FRLocalizedString(@"Error", nil)  message:error.localizedDescription];
    }];
}

- (void)declineRequest:(FRFriendRequestsCellViewModel*)model
{
    [self.output showHudWithType:FRFriendRequestsHudTypeShowHud title:nil message:nil];
    
    [FRFriendsTransport declineRequestId:model.requestId success:^{
        [self.output showHudWithType:FRFriendRequestsHudTypeHideHud title:nil message:nil];
        [self.output friendRequestDone:model];
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRFriendRequestsHudTypeError title:FRLocalizedString(@"Error", nil)  message:error.localizedDescription];
    }];
}


@end
