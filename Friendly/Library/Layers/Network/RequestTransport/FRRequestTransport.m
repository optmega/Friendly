//
//  FRRequestTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRequestTransport.h"
#import "FRNetworkManager.h"
#import "FREventsRequests.h"

static NSString* const kEventRequestsPath = @"event/requests/";
static NSString* const kEventRequestAcceptPath = @"event/user/request/accept/";
static NSString* const kEventRequestDeclinePath = @"event/user/request/decline/";
static NSString* const kUsubscribePath = @"unsubscribe/event/";
static NSString* const kDiscardUserPath = @"event/users";
static NSString* const kSendInvitePath = @"invite/event";
static NSString* const kDeclineInvitePath = @"event/invite/decline/";
static NSString* const kAcceptInvitePartnerPath = @"event/partner/request/accept/";
static NSString* const kDeclineInvitePartnerPath = @"event/partner/request/decline/";
static NSString* const kEventInviteAcceptPath = @"event/invite/accept/";


@implementation FRRequestTransport

+ (void)eventRequestsForEventId:(NSString*)eventId
                        success:(void(^)(FREventsRequest* requests))success
                        failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kEventRequestsPath, eventId];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FREventsRequest* requests = [[FREventsRequest alloc]initWithDictionary:response error:&error];
        
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(requests);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)acceptRequestForRequestId:(NSString*)requestsId
                          success:(void(^)())success
                          failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kEventRequestAcceptPath, requestsId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)declineRequestForId:(NSString*)requestId
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kEventRequestDeclinePath, requestId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)unsubscribeWithEventId:(NSString*)eventId
                       success:(void(^)())success
                       failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kUsubscribePath, eventId];
    [NetworkManager POST_Path:path parameters:@{} success:^(id response) {
      
        
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)discardUserId:(NSString*)userId
          fromEventId:(NSString*)eventId
              success:(void(^)())success
             failure:(void(^)(NSError* error))failure
{
    NSDictionary* parametrs = @{
                                @"event_id" : [NSObject bs_safeString:eventId],
                                 @"user_id" : [NSObject bs_safeString:userId]
                                };

    [NetworkManager DELETE_Path:kDiscardUserPath parameters:parametrs success:^(id response) {
        [FRUserManager sharedInstance].currentUser.allFriendsCount = @(([FRUserManager sharedInstance].currentUser.allFriendsCount.integerValue - 1));
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)sendInviteToEvent:(NSString*)eventId
          toUserId:(NSString*)userId
              success:(void(^)())success
              failure:(void(^)(NSError* error))failure
{
    NSDictionary* parametrs = @{
                                @"event_id" : [NSObject bs_safeString:eventId],
                                @"user_ids" : [NSObject bs_safeString:userId]
                                };
    
    [NetworkManager POST_Path:kSendInvitePath parameters:parametrs success:^(id response) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)declineInviteForId:(NSString*)inviteId
                   success:(void(^)())success
                   failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kDeclineInvitePath, inviteId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];

}

+ (void)declineInviteToCoHostForEventId:(NSString*)eventId
                           success:(void(^)())success
                           failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kDeclineInvitePartnerPath, eventId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];

}

+ (void)acceptInviteToCoHostForEventId:(NSString*)eventId
                               success:(void(^)())success
                               failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kAcceptInvitePartnerPath, eventId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];

}


+ (void)acceptInviteForInviteId:(NSString*)inviteId
                       success:(void(^)())success
                       failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kEventInviteAcceptPath, inviteId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];

}
@end
