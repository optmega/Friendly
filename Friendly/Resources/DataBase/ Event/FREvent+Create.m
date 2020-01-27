//
//  FREvent+Create.m
//  Friendly
//
//  Created by Sergey on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREvent+Create.h"
#import "FRDateManager.h"

@implementation FREvent (Create)

+ (instancetype)initWithEvent:(FREventModel*)event inContext:(NSManagedObjectContext*)context {
   return [self initWithEvent:event withType:FREventCategoryTypeAnother inContext:context];
}


+ (instancetype)initWithEvent:(FREventModel*)event withType:(FREventCategoryType)type {
    return [self initWithEvent:event withType:type inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (instancetype)initWithEvent:(FREventModel*)event withType:(FREventCategoryType)type inContext:(NSManagedObjectContext*)context
{
    FREvent* eventEntity = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", event.id] inContext:context];
    
    if (!eventEntity) {
        eventEntity = [FREvent MR_createEntityInContext:context];
    }
    if (type != FREventCategoryTypeAnother) {
        eventEntity.categoryType = @(type);
    }
    [eventEntity updateWithModel:event];
    
    return eventEntity;
}

- (void)updateWithModel:(FREventModel*)event{
    
//    NSLog(@"date: %@ //// id: %@ ", event.created_at, event.id);
    
    self.eventId = event.id;
    self.info = event.info;
    self.time_ = [FRDateManager dateFromServerWithString:event.time_];
    self.title = event.title;
    self.gender = @(event.gender.integerValue);
    self.createdAt = [FRDateManager dateFromServerWithString:event.created_at];
    self.lon = @(event.lon.doubleValue);
    self.event_start = [FRDateManager dateFromServerWithString:event.event_start];
    self.creator_id = event.creator_id;
    self.partnerHosting = event.partner_hosting;
    self.date_ = [FRDateManager dateFromServerWithString:event.date_];
    self.ageMin = @(event.age_min.integerValue);
    self.lat = @(event.lat.doubleValue);
    self.ageMax = @(event.age_max.integerValue);
    self.slots = @(event.slots.integerValue);
    self.category = event.category;
    self.imageUrl = event.image_url;
    self.categoryId = event.category_id;
    self.tag = event.tag;
    self.partnerIsAccepted = @(event.partner_is_accepted.boolValue);
    self.address = event.address;
    self.requestStatus = @(event.request_status.integerValue);
    [self setValue:@(event.way.integerValue) forKey:@"way"];
    
    [self.userRequest.allObjects enumerateObjectsUsingBlock:^(UserRequest * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self removeUserRequestObject:obj];
        [obj MR_deleteEntityInContext:self.managedObjectContext];
    }];
    
    self.userRequest = nil;
    for (FRRequestsUser* user in event.user_requests)
    {
        UserRequest* request = [UserRequest initWithModel:user inContext:self.managedObjectContext];
        [self addUserRequestObject:request];
    }
    
    self.eventType = @(event.event_type.integerValue);
    self.joinedAt = [FRDateManager dateFromServerWithString:event.joined_at];
    if (event.creator) {
        self.creator = [UserEntity initWithUserModel:event.creator inContext:self.managedObjectContext];
    }
    
    self.partnerUser = [MemberUser initWithModel:[FRJoinUser initWithPartner:event.partner] inContext:self.managedObjectContext];
        
    self.isDelete = @(event.is_deleted.boolValue);
    self.isFeatured = @(event.is_featured.boolValue);
    self.isPopular = @(event.is_popular.boolValue);
    self.thumbnail_url = event.thumbnail_url;
    
    
    self.openToFBFriends = @(event.open_to_fb_friends);
    self.showNumber = @(event.show_number);
    
    self.isJoining = @(event.isJoining.boolValue);
     

    [self removeMemberUsers:self.memberUsers];
 
    self.memberUsers = nil;
    for (FRJoinUser* user in event.users) {
        MemberUser* member = [MemberUser initWithModel:user inContext:self.managedObjectContext];
        [self addMemberUsersObject:member];
    }
}


@end
