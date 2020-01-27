//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInteractorIO.h"

@interface FRCreateEventInteractor : NSObject <FRCreateEventInteractorInput>

@property (nonatomic, weak) id<FRCreateEventInteractorOutput> output;

@end

