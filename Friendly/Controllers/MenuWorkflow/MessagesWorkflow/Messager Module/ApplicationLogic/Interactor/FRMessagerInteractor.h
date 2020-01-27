//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerInteractorIO.h"

@interface FRMessagerInteractor : NSObject <FRMessagerInteractorInput>

@property (nonatomic, weak) id<FRMessagerInteractorOutput> output;

@end

