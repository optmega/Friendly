//
//  FREventTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventTransport.h"
#import "FRNetworkManager.h"
#import "FREventModel.h"
#import "FREventDomainModel.h"
#import "FRCategoryManager.h"
#import "FRGroupRoom.h"

static NSString* const kEventsListPath = @"events";
static NSString* const kCreateEventPath = @"events";
static NSString* const kEventInfoPath = @"event/info/";
static NSString* const kJoinEventPath = @"join/event/";
static NSString* const kHostingEventsPath = @"events/owner";
static NSString* const kJoingEventsPath = @"events/participate";
static NSString* const kFeaturedEventsPath = @"events/featured";
static NSString* const kNearbyEventsPath = @"events/nearby?";
static NSString* const kDiscardUserPath = @"event/users";
static NSString* const kDeleteEventPath = @"event/delete/";
static NSString* const kSearchEvent = @"events/search";
static NSString* const kUpdateEvent = @"event/info/";
static NSString* const kFriendEvents = @"events/friends-events?filtered=";
static NSString* const kEventCalenderPath = @"event/calendar";
static NSString* const kDeleteEventsPath = @"events/deleted";
static NSString* const kCheckFeaturedEvents = @"events/featured/check";


@implementation FREventTransport


+ (void)getFeaturedListWithPage:(NSInteger)page
                        success:(void(^)(FREventModels* models))success
                        failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%ld",kFeaturedEventsPath, (long)page];
    [NetworkManager GET_Path:kFeaturedEventsPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FREventModels* models = [[FREventModels alloc]initWithDictionary:response error:&error];
        if (error) {
            if (failure)
                failure(error);
            return;
        }
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
        NSMutableArray* eventEntitys = [NSMutableArray array];
        for (FREventModel* event in models.top_events) {
            [eventEntitys addObject:[FREvent initWithEvent:event withType:FREventCategoryTypeAnother inContext:context]];
        }
        
        models.eventEntitys = eventEntitys;
        [context MR_saveToPersistentStoreAndWait];
        
        if (success) {
            success(models);
        }
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getNearbyListLat:(NSString*)lat
                     lon:(NSString*)lon
                    page:(NSInteger)page
                 success:(void(^)(NSArray<FREvent*>* events))success
                 failure:(void(^)(NSError* error))failure
{
    
    NSString* path = [NSString stringWithFormat:@"%@lat=%@&lon=%@&page=%ld",kNearbyEventsPath, lat, lon, (long)page];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        
        if (page == 1) {
            NSArray* allEvent = [FREvent MR_findAllInContext:[NSManagedObjectContext MR_defaultContext]];
            [allEvent enumerateObjectsUsingBlock:^(FREvent* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [obj MR_deleteEntityInContext:[NSManagedObjectContext MR_defaultContext]];
            }];
                        
        }
        NSLog(@"%@", response);
        NSError* error;
        FREventModels* model = [[FREventModels alloc]initWithDictionary:response error:&error];
        if (error) {
            if (failure)
                failure(error);
            return;
        }
        
        NSMutableArray* eventModels = [NSMutableArray arrayWithCapacity:model.events.count];
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
            for (FREventModel* event in model.events) {
                [eventModels addObject:[FREvent initWithEvent:event withType:FREventCategoryTypeAnother inContext:context]];
            }
        
        [context MR_saveToPersistentStoreAndWait];
    
        if (success)
            success(eventModels);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getFriendWithFilter:(BOOL)withFilter
                       page:(NSInteger)page
                       list:(void(^)(NSArray<FREvent*>* events))success
                    failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%d&page=%ld", kFriendEvents, withFilter, (long)page];
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FRFriendEventsModel* model = [[FRFriendEventsModel alloc] initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return;
        }
        
        NSMutableArray* eventModels = [NSMutableArray arrayWithCapacity:model.events.count];
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];

        for (FREventModel* event in model.events) {
            [eventModels addObject:[FREvent initWithEvent:event withType:FREventCategoryTypeAnother inContext:context]];
        }
        
        [context MR_saveToPersistentStoreAndWait];
        
        if (success)
            success(eventModels);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)createEventWithModel:(FREventDomainModel*) model
                     success:(void(^)(FREvent* event))success
                     failure:(void(^)(NSError* error))failure
{
     [NetworkManager POST_Path:kCreateEventPath parameters:[model domainModelDictionary] success:^(id response) {
         NSError* error;
         FREventModel* event = [[FREventModel alloc]initWithDictionary:response[@"event"] error:&error];
         if (error)
         {
             if (failure)
                 failure(error);
             return ;
         }
         
        __block FREvent* eventEntity;
         NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
             eventEntity = [FREvent initWithEvent:event withType:0 inContext:context];
             CurrentUser* user = [context objectWithID:[[FRUserManager sharedInstance].currentUser objectID]];
             
             [user addHostingEventsObject:eventEntity];
         
         FRGroupRoom* group = [FRGroupRoom initOrUpdateGroupRoomWithModel:eventEntity inContext:context];
         
         group.lastMessageDate = [NSDate date];
         
         [context MR_saveToPersistentStoreAndWait];
             if (success)
                 success(eventEntity);
         
         
     } failure:^(NSError *error) {
         if (failure)
             failure(error);
     }];
}


+ (void)getEventInfoWithId:(NSString*)eventId
                   success:(void(^)(FREvent* event))success
                   failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kEventInfoPath, [NSObject bs_safeString:eventId]];
    __block FREvent* eventEntity;
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FREventModel* event = [[FREventModel alloc] initWithDictionary:response[@"event"] error:&error];
        if (error)
        {
            failure(error);
            return ;
        }
        
        NSManagedObjectContext* loocalContext = [NSManagedObjectContext MR_defaultContext];
        eventEntity = [FREvent initWithEvent:event withType:0 inContext:loocalContext];
        [loocalContext MR_saveToPersistentStoreAndWait];
        if (success)
            success(eventEntity);
        
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getEventInfoWithId:(NSString*)eventId
                   context:(NSManagedObjectContext *)context
                   success:(void(^)(FREvent* event))success
                   failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kEventInfoPath, [NSObject bs_safeString:eventId]];
    __block FREvent* eventEntity;
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FREventModel* event = [[FREventModel alloc] initWithDictionary:response[@"event"] error:&error];
        if (error)
        {
            failure(error);
            return ;
        }
        
        NSManagedObjectContext* loocalContext = [NSManagedObjectContext MR_defaultContext];
            eventEntity = [FREvent initWithEvent:event withType:0 inContext:(context != nil ? context : loocalContext)];
        [loocalContext MR_saveToPersistentStoreAndWait];
            if (success)
                success(eventEntity);
        
    
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)joinEventWithId:(NSString*)eventId
                message:(NSString*)requestMessage
                success:(void(^)(void))success
                failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kJoinEventPath, [NSObject bs_safeString:eventId]];
    [NetworkManager POST_Path:path parameters:@{@"request_message":[NSObject bs_safeString:requestMessage]} success:^(id response) {
        
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getHostingEventWithSuccess:(void(^)(NSArray<FREvent*>* events))success
                           failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kHostingEventsPath parameters:@{} success:^(id response) {
        
            NSError* error;
            FREventModels* models = [[FREventModels alloc]initWithDictionary:response error:&error];
            if (error) {
                failure(error);
                return;
            }
            
            NSMutableArray* eventModels = [NSMutableArray arrayWithCapacity:models.events.count];

        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            [currentUser removeHostingEvents:currentUser.hostingEvents];
            
            for (FREventModel* event in models.events) {
                FREvent* eventHosting = [FREvent initWithEvent:event withType:FREventCategoryTypeHosting inContext:context];
                [currentUser addHostingEventsObject:eventHosting];
                
                [eventModels addObject:eventHosting];
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (success)
                success(eventModels);
        }];
    
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getJoingEventWithSuccess:(void(^)(NSArray<FREvent*>* events))success
                         failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kJoingEventsPath parameters:@{} success:^(id response) {
    
        NSError* error;
        FREventModels* models = [[FREventModels alloc]initWithDictionary:response error:&error];
        if (error) {
            failure(error);
            return;
        }
        
        NSMutableArray* eventModels = [NSMutableArray arrayWithCapacity:models.events.count];
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            [currentUser removeJoingEvents:currentUser.joingEvents];
            
            for (FREventModel* event in models.events) {
                FREvent* eventJoing = [FREvent initWithEvent:event withType:FREventCategoryTypeAttending inContext:context];
                [currentUser addJoingEventsObject:eventJoing];
                [eventModels addObject:eventJoing];
            }
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (success)
                success(eventModels);
        }];
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)deleteEventWithId:(NSString*)eventId
                  success:(void(^)())success
                  failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kDeleteEventPath, eventId];
    [NetworkManager DELETE_Path:path parameters:@{} success:^(id response) {
       

        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
            FREvent* eventForDelete = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId] inContext:context];
            [eventForDelete MR_deleteEntityInContext:context];
        
        [context MR_saveToPersistentStoreAndWait];
        
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)searchEventsByTitle:(NSString*)eventTitle
                            success:(void(^)(FREventSearchEntityModels* models))success
                            failure:(void(^)(NSError* error))failure
{
        NSString* encodedTitle = [NSString stringWithFormat:@"?q=%@", [eventTitle stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSString* categoryId = [[FRCategoryManager getCategoryDictionary] valueForKey:eventTitle];
        if (categoryId!=nil)
        {
            encodedTitle = [NSString stringWithFormat:@"?category=%@", categoryId];
        }
        NSString* path = [NSString stringWithFormat:@"%@%@",kSearchEvent, encodedTitle];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FREventSearchModels* models = [[FREventSearchModels alloc]initWithDictionary:response error:&error];
        if (error) {
            failure(error);
            return;
        }
        
        NSMutableArray* entityEvents = [NSMutableArray arrayWithCapacity:models.events.count];
        
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

            [models.events enumerateObjectsUsingBlock:^(FREventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [entityEvents addObject:[FREvent initWithEvent:obj withType:0 inContext:context]];
            }];
            
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            FREventSearchEntityModels* entityModels = [FREventSearchEntityModels new];
            entityModels.related_category = models.related_category;
            entityModels.discover_people = models.discover_people;
            entityModels.events = entityEvents;
            
            if (success)
                success(entityModels);
        }];
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)updateEventWithId:(NSString*)eventId
                    event:(FREventDomainModel*)eventModel
                  success:(void(^)(FREventModel* event))success
                  failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kUpdateEvent, eventId];
    [NetworkManager PUT_Path:path parameters:[eventModel domainModelDictionary] success:^(id response) {
        
        NSError* error;
        FREventModel* event = [[FREventModel alloc]initWithDictionary:response[@"event"] error:&error];
        if (success)
            success(event);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}


+ (void)getApproveEventForCalendar:(void(^)(NSArray<FREvent*>*events))success
                           failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kEventCalenderPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRFriendEventsModel* model = [[FRFriendEventsModel alloc] initWithDictionary:response error:&error];
        if (error)
        {
            failure(error);
            return ;
        }
        
        NSMutableArray* array = [NSMutableArray arrayWithCapacity:model.events.count];
        
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {
            
            [model.events enumerateObjectsUsingBlock:^(FREventModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [array addObject:[FREvent initWithEvent:obj withType:0 inContext:context]];
            }];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (success)
                success(array);
        }];
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)postEventToCalendar:(NSString*)eventId
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure
{
    [NetworkManager POST_Path:kEventCalenderPath parameters:@{@"event_id" : eventId} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (FREvent*)getEventForId:(NSString*)eventId
                  success:(void(^)(FREvent* event))success
                  failure:(void(^)(NSError* error))failure
{
    return [self getEventForId:eventId context:nil success:success failure:failure];
}

//говнецо
+ (FREvent*)getEventForId:(NSString*)eventId
                  context:(NSManagedObjectContext *)context
                  success:(void(^)(FREvent* event))success
                  failure:(void(^)(NSError* error))failure
{
    if (context == nil) {
        context = [NSManagedObjectContext MR_defaultContext];
    }
    
    FREvent* event = [FREvent MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"eventId == %@", eventId] inContext:context];
    if (!event) {
        [self getEventInfoWithId:eventId context:context success:success failure:failure];
    }
    
    return event;
}

+ (void)getDeleteEventIdWithSuccess:(void (^)(NSArray *))success
                            failure:(void (^)(NSError *))failure {
    
    [NetworkManager GET_Path:kDeleteEventsPath parameters:nil success:^(id response) {
        
        NSError* error;
        FREventAllDeleteModel* models = [[FREventAllDeleteModel alloc] initWithDictionary:response error:&error];
        if (error) {
            if (failure) {
                failure(error);
                return;
            }
        }
            success(models.event_ids);
            
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)checkFeaturedEvents:(void(^)(FREventFeatureModel* model))success
                    failure:(void(^)(NSError* error))failure {
    
    [NetworkManager GET_Path:kCheckFeaturedEvents parameters:nil success:^(id response) {
        
        NSError* error;
        FREventFeatureModel* feature = [[FREventFeatureModel alloc]initWithDictionary:response error:&error];
        if (error) {
            if (failure) {
                failure(error);
            }
            return;
        }
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            [UserEntity initWithUserModel:feature.invited_last inContext:localContext];
        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            if (success) {
                success(feature);
            }
        }];
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}




@end
