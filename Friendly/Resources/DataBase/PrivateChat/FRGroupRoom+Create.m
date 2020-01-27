//
//  FRGroupRoom+Create.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupRoom+Create.h"
#import "FRDateManager.h"
#import "FRMemberUser.h"


@implementation FRGroupRoom (Create)

+ (instancetype)groupRoomForId:(NSString*)eventId inContext:(NSManagedObjectContext*)context {
    
    FRGroupRoom* room = [FRGroupRoom MR_findFirstByAttribute:@"eventId" withValue:eventId inContext:context];
    if (!room)
    {
        room = [FRGroupRoom MR_createEntityInContext:context];
        room.isGroupChat = @(true);
        room.eventId = eventId;
    }
    
    return room;
}

+ (instancetype)initOrUpdateGroupRoomWithModel:(FREvent*)model inContext:(NSManagedObjectContext*)context
{
    
    FREvent* event = [context objectWithID:model.objectID];
    
    FRGroupRoom* room = [FRGroupRoom MR_findFirstByAttribute:@"eventId" withValue:event.eventId inContext:context];
    if (!room)
    {
        room = [FRGroupRoom MR_createEntityInContext:context];
        room.eventId = event.eventId;
    }
    room.eventDate = event.event_start;
    room.eventName = event.title;
    room.roomTitle = event.title;
    room.event = event;
    room.isGroupChat = @(true);
    
    room.joined_at = event.joinedAt;
    
    return room;
}

+ (NSSet*)membersFromEvent:(FREventModel*)event
{
    NSMutableSet* set = [NSMutableSet set];
    
    [event.users enumerateObjectsUsingBlock:^(FRJoinUser* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FRMemberUser* member = [FRMemberUser MR_createEntity];
        [member update:obj];
        if (member.userId.integerValue != [FRUserManager sharedInstance].userId.integerValue){
            [set addObject:member];
        }
    }];
    
    FRMemberUser* member = [FRMemberUser MR_createEntity];
    [member udpateWithUser:event.creator];
    if (member.userId.integerValue != [FRUserManager sharedInstance].userId.integerValue){
        [set addObject:member];
    }
    
    return set;
}

@end
