//
//  FRAddInterestsCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInterestsModel.h"

@protocol FRAddInterestsCellViewModelDelegate <NSObject>

- (void)interestSelected:(FRInterestsModel*)interest;

@end

@interface FRAddInterestsCellViewModel : NSObject

+ (instancetype)initWithModel:(FRInterestsModel*)model;

@property (nonatomic, weak) id<FRAddInterestsCellViewModelDelegate> delegate;
@property (nonatomic, strong) FRInterestsModel* model;
@property (nonatomic, assign) BOOL isCheck;

- (void)selectedInterest:(NSString*)interest;

@end
