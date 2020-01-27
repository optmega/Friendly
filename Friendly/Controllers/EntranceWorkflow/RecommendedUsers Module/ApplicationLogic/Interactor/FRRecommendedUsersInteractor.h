//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersInteractorIO.h"

@interface FRRecommendedUsersInteractor : NSObject <FRRecommendedUsersInteractorInput>

@property (nonatomic, weak) id<FRRecommendedUsersInteractorOutput> output;

@end

