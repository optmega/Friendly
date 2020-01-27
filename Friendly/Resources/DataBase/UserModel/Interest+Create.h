//
//  Interest+Create.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "Interest.h"
#import "FRInterestsModel.h"

@interface Interest (Create)

+ (instancetype)initWithModel:(FRInterestsModel*)interest inContext:(NSManagedObjectContext*)context;
- (FRInterestsModel*)interest;

@end
