//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersDataSource.h"
#import "BSMemoryStorage.h"
#import "FRRecommendedUsersCell.h"
#import "FRUserModel.h"
#import "FRRecomendedUserModel.h"

@interface FRRecommendedUsersDataSource ()<FRRecommendedUsersCellViewModelDelegate>

@end

@implementation FRRecommendedUsersDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorageWithModels:(FRRecomendedUserModels*)model
{
    if (!BSIsEmpty(model.recommended_users))
    {
//        NSArray* users = [model.recommended_users sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"interests" ascending:YES]]];
        
        
        NSArray* users = [model.recommended_users sortedArrayUsingComparator:^NSComparisonResult(FRUserModel* obj1, FRUserModel* obj2)
        {
            if([obj1.interests count] > [obj2.interests count])
                return NSOrderedAscending;
            if([obj1.interests count] < [obj2.interests count])
                return NSOrderedDescending;
            return NSOrderedSame;
        }];
        
        [self.storage addItems:[self _convertModelToViewModel:users]];
    }
}


#pragma mark - Private

- (NSArray*)_convertModelToViewModel:(NSArray*)models
{
    NSMutableArray* viewModels = [NSMutableArray array];
    [models enumerateObjectsUsingBlock:^(FRUserModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRRecommendedUsersCellViewModel* viewModel = [FRRecommendedUsersCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [viewModels addObject:viewModel];
    }];
    
    return viewModels;
}

- (void)reloadData
{
    [self.storage reloadItems:self.storage.storageArray];
}

#pragma mark - FRRecommendedUsersCellViewModelDelegate

- (void)addUser:(FRRecommendedUsersCellViewModel*)userModel
{
    [self.delegate addUserWithUserModel:userModel];
}

- (void)showUserProfile:(NSString *)userId
{
    [self.delegate showUserProfile:userId];
}



@end
