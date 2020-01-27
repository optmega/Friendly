//
//  FRRequestTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@class FREventsRequest;

@interface FRRequestTransport : NSObject

+ (void)eventRequestsForEventId:(NSString*)eventId
                        success:(void(^)(FREventsRequest* requests))success
                        failure:(void(^)(NSError* error))failure;

+ (void)acceptRequestForRequestId:(NSString*)requestsId
                          success:(void(^)())success
                          failure:(void(^)(NSError* error))failure;

+ (void)declineRequestForId:(NSString*)requestId
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure;

+ (void)discardUserId:(NSString*)userId
          fromEventId:(NSString*)eventId
              success:(void(^)())success
             failure:(void(^)(NSError* error))failure;

+ (void)unsubscribeWithEventId:(NSString*)eventId
                       success:(void(^)())success
                       failure:(void(^)(NSError* error))failure;

+ (void)sendInviteToEvent:(NSString*)eventId
               toUserId:(NSString*)userId
                  success:(void(^)())success
                  failure:(void(^)(NSError* error))failure;

+ (void)declineInviteForId:(NSString*)inviteId
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure;

+ (void)declineInviteToCoHostForEventId:(NSString*)eventId
                   success:(void(^)())success
                   failure:(void(^)(NSError* error))failure;

+ (void)acceptInviteToCoHostForEventId:(NSString*)eventId
                          success:(void(^)())success
                          failure:(void(^)(NSError* error))failure;

+ (void)acceptInviteForInviteId:(NSString*)inviteId
                       success:(void(^)())success
                       failure:(void(^)(NSError* error))failure;


@end
