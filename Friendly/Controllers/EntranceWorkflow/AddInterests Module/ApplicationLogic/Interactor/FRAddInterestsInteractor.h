//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsInteractorIO.h"

@interface FRAddInterestsInteractor : NSObject <FRAddInterestsInteractorInput>

@property (nonatomic, weak) id<FRAddInterestsInteractorOutput> output;
@property (nonatomic, strong) NSMutableArray* tagsArray;
@property (nonatomic, strong) NSMutableArray* interests;



@end

