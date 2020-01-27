//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FRFriendFamiliarCellViewModel, FRFriendRequestsCellViewModel;


@protocol FRFriendRequestsDataSourceDelegate <NSObject>

- (void)updateViewWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends;

- (void)selectedAdd:(FRFriendFamiliarCellViewModel*)model;
- (void)selectedRemove:(FRFriendFamiliarCellViewModel*)model;
- (void)selectedAccept:(FRFriendRequestsCellViewModel*)model;
- (void)selectedDecline:(FRFriendRequestsCellViewModel*)model;
- (void)showUserProfileWithEntity:(UserEntity*)user;
- (void)showUserProfileWithUserId:(NSString*)userId;

@end

@interface FRFriendRequestsDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRFriendRequestsDataSourceDelegate> delegate;

- (void)setupStorageWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends;
@end
