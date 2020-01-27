//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryInteractorIO.h"

@interface FRSearchEventByCategoryInteractor : NSObject <FRSearchEventByCategoryInteractorInput>

@property (nonatomic, weak) id<FRSearchEventByCategoryInteractorOutput> output;

@end

