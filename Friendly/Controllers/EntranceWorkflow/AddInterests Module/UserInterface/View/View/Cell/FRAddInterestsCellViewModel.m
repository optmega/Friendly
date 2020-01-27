//
//  FRAddInterestsCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsCellViewModel.h"

@implementation FRAddInterestsCellViewModel


+ (instancetype)initWithModel:(FRInterestsModel*)model
{
    FRAddInterestsCellViewModel* viewModel = [self new];
    viewModel.model = model;
    return viewModel;
}

- (void)selectedInterest:(NSString*)interest
{
    [self.delegate interestSelected:self.model];
}

@end
