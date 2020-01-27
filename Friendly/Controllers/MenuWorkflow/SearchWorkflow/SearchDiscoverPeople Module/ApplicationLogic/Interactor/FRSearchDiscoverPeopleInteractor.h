//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleInteractorIO.h"

@interface FRSearchDiscoverPeopleInteractor : NSObject <FRSearchDiscoverPeopleInteractorInput>

@property (nonatomic, weak) id<FRSearchDiscoverPeopleInteractorOutput> output;

@end

