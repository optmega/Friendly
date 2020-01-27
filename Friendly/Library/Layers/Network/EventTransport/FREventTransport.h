//
//  FREventTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREvent.h"
#import "FREventModel.h"

@class FREventModels, FREventModel, FREventDomainModel, FRFriendEventsModel, FREventSearchModels, FREventFeatureModel;

@interface FREventTransport : NSObject


+ (void)getFeaturedListWithPage:(NSInteger)page
                        success:(void(^)(FREventModels* models))success
                        failure:(void(^)(NSError* error))failure;

+ (void)getNearbyListLat:(NSString*)lat
                     lon:(NSString*)lon
                    page:(NSInteger)page
                 success:(void(^)(NSArray<FREvent*>* events))success
                 failure:(void(^)(NSError* error))failure;

+ (void)getFriendWithFilter:(BOOL)withFilter
                       page:(NSInteger)page
                       list:(void(^)(NSArray<FREvent*>* events))success
                    failure:(void(^)(NSError* error))failure;

+ (void)createEventWithModel:(FREventDomainModel*) model
                     success:(void(^)(FREvent* event))success
                     failure:(void(^)(NSError*))failure;

+ (void)getEventInfoWithId:(NSString*)eventId
                   success:(void(^)(FREvent* event))success
                   failure:(void(^)(NSError* error))failure;


+ (void)joinEventWithId:(NSString*)eventId
                message:(NSString*)requestMessage
                success:(void(^)(void))success
                failure:(void(^)(NSError* error))failure;

+ (void)getHostingEventWithSuccess:(void(^)(NSArray<FREvent*>* events))success
                           failure:(void(^)(NSError* error))failure;

+ (void)getJoingEventWithSuccess:(void(^)(NSArray<FREvent*>* events))success
                         failure:(void(^)(NSError* error))failure;

+ (void)deleteEventWithId:(NSString*)eventId
                   success:(void(^)())success
                   failure:(void(^)(NSError* error))failure;

+ (void)searchEventsByTitle:(NSString*)eventTitle
                            success:(void(^)(FREventSearchEntityModels* models))success
                            failure:(void(^)(NSError* error))failure;

+ (void)updateEventWithId:(NSString*)eventId
                    event:(FREventDomainModel*)eventModel
                  success:(void(^)(FREventModel* event))success
                  failure:(void(^)(NSError* error))failure;

+ (void)getApproveEventForCalendar:(void(^)(NSArray<FREvent*>*events))success
                           failure:(void(^)(NSError* error))failure;

+ (void)postEventToCalendar:(NSString*)eventId
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure;

+ (FREvent*)getEventForId:(NSString*)eventId
                  success:(void(^)(FREvent* event))success
                  failure:(void(^)(NSError* error))failure;

+ (FREvent*)getEventForId:(NSString*)eventId
                  context:(NSManagedObjectContext *)context
                  success:(void(^)(FREvent* event))success
                  failure:(void(^)(NSError* error))failure;

+ (void)getDeleteEventIdWithSuccess:(void(^)(NSArray* eventId))success
                            failure:(void(^)(NSError* error))failure;

+ (void)checkFeaturedEvents:(void(^)(FREventFeatureModel* model))success
                    failure:(void(^)(NSError* error))failure;

+ (void)postInviteReference:(NSString*)userId
                    success:(void(^)(void))success
                    failure:(void(^)(NSError* error))failure;

@end
