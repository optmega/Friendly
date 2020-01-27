//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileInteractorIO.h"

@interface FREditProfileInteractor : NSObject <FREditProfileInteractorInput>

@property (nonatomic, weak) id<FREditProfileInteractorOutput> output;

@end

