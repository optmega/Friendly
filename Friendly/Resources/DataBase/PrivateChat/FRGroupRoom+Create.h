//
//  FRGroupRoom+Create.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupRoom.h"
#import "FREventModel.h"

@interface FRGroupRoom (Create)

+ (instancetype)groupRoomForId:(NSString*)eventId inContext:(NSManagedObjectContext*)context;
+ (instancetype)initOrUpdateGroupRoomWithModel:(FREvent*)model inContext:(NSManagedObjectContext*)context;

@end
