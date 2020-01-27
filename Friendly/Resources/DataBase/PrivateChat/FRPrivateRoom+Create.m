//
//  FRPrivateRoom+Create.m
//  Friendly
//
//  Created by Dmitry on 25.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoom+Create.h"

@implementation FRPrivateRoom (Create)

+ (instancetype)createPrivateRoomForId:(NSString*)roomId inContext:(NSManagedObjectContext*)context {
    
    FRPrivateRoom* room = [FRPrivateRoom MR_findFirstByAttribute:@"roomId" withValue:roomId inContext:context];
    if (!room)
    {
        room = [FRPrivateRoom MR_createEntityInContext:context];
        room.roomId = roomId;
    }
    
    return room;
}


@end
