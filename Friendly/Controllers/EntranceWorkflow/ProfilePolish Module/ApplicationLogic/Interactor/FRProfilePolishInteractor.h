//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishInteractorIO.h"

@interface FRProfilePolishInteractor : NSObject <FRProfilePolishInteractorInput>

@property (nonatomic, weak) id<FRProfilePolishInteractorOutput> output;

@end

