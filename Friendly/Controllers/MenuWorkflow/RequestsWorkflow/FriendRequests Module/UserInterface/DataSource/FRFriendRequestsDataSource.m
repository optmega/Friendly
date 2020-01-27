//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsDataSource.h"
#import "BSMemoryStorage.h"
#import "FRUserModel.h"
#import "FRFriendFamiliarCellViewModel.h"
#import "FRFriendRequestsCellViewModel.h"

@interface FRFriendRequestsDataSource () <FRFriendRequestsCellViewModelDelegate, FRFriendFamiliarCellViewModelDelegate>

@end

@implementation FRFriendRequestsDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorageWithFriendRequests:(NSArray*)friendRequests potentialFriends:(NSArray*)potentialFriends
{
    [self.delegate updateViewWithFriendRequests:[self _friendRequestsViewModelFromModel:friendRequests]
                               potentialFriends:[self _potentialFriendsViewModelsFromModels:potentialFriends]];
}


#pragma mark - Private

- (NSArray*)_friendRequestsViewModelFromModel:(NSArray*)models
{
    NSMutableArray* viewModels = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FRFriendlyRequestModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRFriendRequestsCellViewModel* viewModel = [FRFriendRequestsCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [viewModels addObject:viewModel];
    }];
    return viewModels;
}

- (NSArray*)_potentialFriendsViewModelsFromModels:(NSArray*)models
{
    NSMutableArray* viewModels = [NSMutableArray array];
    [models enumerateObjectsUsingBlock:^(FRPotentialFriendModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRFriendFamiliarCellViewModel* viewModel = [FRFriendFamiliarCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [viewModels addObject:viewModel];
    }];
    
    return viewModels;
}


#pragma mark - FRFriendFamiliarCellViewModelDelegate

- (void)selectedAdd:(FRFriendFamiliarCellViewModel*)model
{
    [self.delegate selectedAdd:model];
}

- (void)selectedRemove:(FRFriendFamiliarCellViewModel*)model
{
    [self.delegate selectedRemove:model];
}


#pragma mark - FRFriendRequestsCellViewModelDelegate

- (void)selectedAccept:(FRFriendRequestsCellViewModel*)model
{
    [self.delegate selectedAccept:model];
}

- (void)selectedDecline:(FRFriendRequestsCellViewModel*)model
{
    [self.delegate selectedDecline:model];
}

- (void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.delegate showUserProfileWithEntity:user];
}

- (void)showUserProfileWithUserId:(NSString*)userId {
    [self.delegate showUserProfileWithUserId:userId];
}

@end
