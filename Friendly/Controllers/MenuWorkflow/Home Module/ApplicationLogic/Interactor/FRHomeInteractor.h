//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeInteractorIO.h"

@interface FRHomeInteractor : NSObject <FRHomeInteractorInput>

@property (nonatomic, weak) id<FRHomeInteractorOutput> output;

@end

