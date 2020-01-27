//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleDataSource.h"
#import "BSMemoryStorage.h"
#import "FRSearchPeopleCellViewModel.h"
#import "FRSearchPeopleInviteCellViewModel.h"
#import "FRSearchUserModel.h"
#import "FRFriendsTransport.h"

@interface FRSearchDiscoverPeopleDataSource () <FRSearchPeopleCellViewModelDelegate>
@end

@implementation FRSearchDiscoverPeopleDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage
{
    FRSearchPeopleInviteCellViewModel* inviteModel = [FRSearchPeopleInviteCellViewModel new];
    [self.storage addItem:inviteModel];
}

- (void)updateStorageWithUsers:(FRSearchUsers*)usersModel
{
    NSMutableArray* array = [NSMutableArray array];
    FRSearchPeopleInviteCellViewModel* inviteModel = [FRSearchPeopleInviteCellViewModel new];
    [array addObject:inviteModel];
    [array addObjectsFromArray:[self _viewModelFromModel:usersModel.users]];
    
    [self.storage removeAndAddNewItems:array];
}


#pragma mark - Private

- (NSArray*)_viewModelFromModel:(NSArray*)models
{
    NSMutableArray* viewModels = [NSMutableArray array];
    
    [models enumerateObjectsUsingBlock:^(FRSearchUserModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRSearchPeopleCellViewModel* viewModel = [FRSearchPeopleCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [viewModels addObject:viewModel];
    }];
    
    return viewModels;
}

- (void)profileSelectedWithUserId:(NSString*)userId
{
    [self.delegate profileSelectedWithUserId:userId];
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

@end
