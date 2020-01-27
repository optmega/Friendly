//
//  CreateEvent+Create.h
//  Friendly
//
//  Created by Sergey on 02.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "CreateEvent.h"
#import "FREventDomainModel.h"

@interface CreateEvent (Create)

+ (instancetype)createFromDomain:(FREventDomainModel*)domainModel inContext:(NSManagedObjectContext*)context;
- (FREventDomainModel*)domainModel;
@end
