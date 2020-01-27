//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenInteractorIO.h"

@interface FRHomeScreenInteractor : NSObject <FRHomeScreenInteractorInput>

@property (nonatomic, weak) id<FRHomeScreenInteractorOutput> output;

@end

