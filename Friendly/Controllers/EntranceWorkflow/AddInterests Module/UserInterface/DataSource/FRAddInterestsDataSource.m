//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsDataSource.h"
#import "BSMemoryStorage.h"
#import "FRInterestsModel.h"
#import "FRAddInterestsCellViewModel.h"


@interface FRAddInterestsDataSource () <FRAddInterestsCellViewModelDelegate>

@end
@implementation FRAddInterestsDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorageWithModel:(FRInterestsModels*)model
{
    if (!BSIsEmpty(model.interests))
    {
        [self.storage addItems:[self _convertModelToViewModel:model.interests]];
    }
}

- (void)addInterests:(FRInterestsModel*)interest
{
    FRAddInterestsCellViewModel* viewModel = [FRAddInterestsCellViewModel initWithModel:interest];
    viewModel.delegate = self;
    viewModel.isCheck = YES;
    [self.storage addItem:viewModel atIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.storage scrollToTop];
}

#pragma mark - Private

- (NSArray*)_convertModelToViewModel:(NSArray*)array
{
    NSMutableArray* ar = [NSMutableArray array];
    
    [array enumerateObjectsUsingBlock:^(FRInterestsModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRAddInterestsCellViewModel* viewModel = [FRAddInterestsCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [ar addObject:viewModel];
    }];
    
    return ar;
}

- (void)interestSelected:(FRInterestsModel*)interest
{
    [self.delegate selectedInterest:interest];
}

@end
