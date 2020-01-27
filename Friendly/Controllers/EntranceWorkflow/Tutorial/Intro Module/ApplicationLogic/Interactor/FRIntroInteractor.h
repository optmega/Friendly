//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroInteractorIO.h"

@interface FRIntroInteractor : NSObject <FRIntroInteractorInput>

@property (nonatomic, weak) id<FRIntroInteractorOutput> output;

@end

