//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRFriendRequestsDataSource, FRFriendFamiliarCellViewModel, FRFriendRequestsCellViewModel;

@protocol FRFriendRequestsViewInterface <NSObject>

- (void)updateDataSource:(FRFriendRequestsDataSource*)dataSource;
- (void)updateViewWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends;

- (void)removePotentialFriend:(FRFriendFamiliarCellViewModel*)model;
- (void)removeFriendRequest:(FRFriendRequestsCellViewModel*)model;
                               

@end
