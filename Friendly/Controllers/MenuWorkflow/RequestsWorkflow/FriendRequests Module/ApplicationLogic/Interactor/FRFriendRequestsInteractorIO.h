//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRFriendFamiliarCellViewModel, FRFriendRequestsCellViewModel;

typedef NS_ENUM(NSInteger, FRFriendRequestsHudType) {
    FRFriendRequestsHudTypeError,
    FRFriendRequestsHudTypeShowHud,
    FRFriendRequestsHudTypeHideHud,
};

@protocol FRFriendRequestsInteractorInput <NSObject>

- (void)loadData;

- (void)addUser:(FRFriendFamiliarCellViewModel*)model;
- (void)removeUser:(FRFriendFamiliarCellViewModel*)model;

- (void)acceptRequst:(FRFriendRequestsCellViewModel*)model;
- (void)declineRequest:(FRFriendRequestsCellViewModel*)model;


@end


@protocol FRFriendRequestsInteractorOutput <NSObject>

- (void)potentialRequstDone:(FRFriendFamiliarCellViewModel*)model;
- (void)friendRequestDone:(FRFriendRequestsCellViewModel*)model;

- (void)dataLoadedWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFiends;
- (void)showHudWithType:(FRFriendRequestsHudType)type title:(NSString*)title message:(NSString*)message;

@end