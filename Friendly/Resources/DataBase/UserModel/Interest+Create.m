//
//  Interest+Create.m
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "Interest+Create.h"
#import "FRDateManager.h"

@implementation Interest (Create)

+ (instancetype)initWithModel:(FRInterestsModel*)interest inContext:(NSManagedObjectContext*)context
{
    Interest* model = [Interest MR_createEntityInContext:context];
    model.createdAt = [FRDateManager dateFromServerWithString: interest.created_at];
    model.title = interest.title;
    model.isMutual = [NSNumber numberWithBool: interest.is_mutual.boolValue];
    return model;
}

- (FRInterestsModel*)interest
{
    FRInterestsModel* model = [FRInterestsModel new];
    model.created_at = [FRDateManager dateStringForServerFromDate:self.createdAt];
    model.title = self.title;
    model.is_mutual = self.isMutual.stringValue;
    
    return model;
}
@end
