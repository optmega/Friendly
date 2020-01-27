//
//  Filter+Create.h
//  Friendly
//
//  Created by Dmitry on 24.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//



@interface Filter (Create)

+ (instancetype)initFilterWith:(FRFilterModel*)filterModel inContext:(NSManagedObjectContext*)context;

@end
