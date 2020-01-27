//
//  FRFriendsTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendsTransport.h"
#import "FRUserModel.h"
#import "FRNetworkManager.h"
#import "FRFriendsListModel.h"
#import "FRInviteModel.h"


static NSString* const kMyFriendsListPath = @"friends";
static NSString* const kFriendlyRequestsPath = @"friendly/requests";
static NSString* const kFriendlyRequestAcceptPath = @"friendly/request/accept/";
static NSString* const kFriendlyRequestDeclinePath = @"friendly/request/decline/";
static NSString* const kInviteUserPath = @"invite/user/";
static NSString* const kRemoveFromPotentialFriendsPath = @"you_may_know/user/dont_show?user_id=";
static NSString* const kInviteToEventsForMe = @"invites/events/me";
static NSString* const kBlockUserPath = @"user/blocks";
static NSString* const kReportUserPath = @"reports";
static NSString* const kCandidatesPath = @"event/candidates/";
static NSString* const kAvailableForMeetFriends = @"friends/available_for_meet";
static NSString* const kRemoveUserPath = @"friends?id=";

@implementation FRFriendsTransport


+ (void)getAvailableForMeetFriendsPage:(NSInteger)page
                               success:(void(^)(FRFriendsListModel* friendsList))success
                               failure:(void(^)(NSError* error))failure {
    
    NSString* path = [NSString stringWithFormat:@"%@?page=%ld", kAvailableForMeetFriends, (long)page];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FRFriendsListModel* list = [[FRFriendsListModel alloc]initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        if ( [FRUserManager sharedInstance].currentUser.objectID != nil)
        {
            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            NSArray* users = [UserEntity MR_findAllWithPredicate:[NSPredicate predicateWithFormat:@"availableStatus == %@", @0]];
            
            
            [users enumerateObjectsUsingBlock:^(UserEntity * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                obj.availableStatus = @(1);
            }];
            
        
            
            NSDictionary* paginator = response[@"paginator"];
            NSString* countUsers = paginator[@"items_count"];
            currentUser.availableToMeetUsersCount = [NSNumber numberWithInt:countUsers.intValue];
            for (FRUserModel* userModel in list.friends) {
                UserEntity* friend = [UserEntity initWithUserModel:userModel inContext:context];
                [currentUser addFriendsObject:friend];
            }
        }
        [context MR_saveToPersistentStoreAndWait];
        
        if (success)
            success(list);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
    
}

+ (void)getMyFriendsListWithSuccess:(void(^)(FRFriendsListModel* friendsList))success
                            failure:(void(^)(NSError* error))failure {
    [self getMyFriendsListPage:1 success:success failure:failure];
}


+ (void)getMyFriendsListPage:(NSInteger)page
                     success:(void(^)(FRFriendsListModel* friendsList))success
                     failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@?page=%ld", kMyFriendsListPath, (long)page];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        
        
//        if (page == 1) {
//            CurrentUser* currentUser = [[FRUserManager sharedInstance] currentUser];
//            [currentUser removeFriends:currentUser.friends];
//        }
        
        FRFriendsListModel* list = [[FRFriendsListModel alloc]initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
        if ( [FRUserManager sharedInstance].currentUser.objectID != nil)
        {
            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            
            NSDictionary* paginator = response[@"paginator"];
            NSString* countUsers = paginator[@"items_count"];
            currentUser.allFriendsCount = [NSNumber numberWithInt:countUsers.intValue];

            
            for (FRUserModel* userModel in list.friends) {
                UserEntity* friend = [UserEntity initWithUserModel:userModel inContext:context];
                [currentUser addFriendsObject:friend];
            }
        }
        [context MR_saveToPersistentStoreAndWait];
        
        if (success)
            success(list);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getCandidatesListWithEvent:(NSString*)eventId
                              page:(NSNumber*)page
                           success:(void(^)(FRCandidatesListModel* friendsList, NSString* pageCount))success
                           failure:(void(^)(NSError* error))failure
{
    
    [NetworkManager GET_Path:[NSString stringWithFormat:@"%@%@?page=%@", kCandidatesPath, eventId, page] parameters:@{@"page_size" : @"6"} success:^(id response) {
        NSError* error;
        FRCandidatesListModel* list = [[FRCandidatesListModel alloc]initWithDictionary:response error:&error];
        NSDictionary* paginator = [response objectForKey:@"paginator"];
        NSString* pageCount = [paginator objectForKey:@"pages"];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(list, pageCount);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}


+ (void)getFriendlyRequestsWithSuccess:(void(^)(FRFriendlyRequestsModel* requests))success
                               failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kFriendlyRequestsPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRFriendlyRequestsModel* friendlyRequests = [[FRFriendlyRequestsModel alloc] initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return ;
        }
        if (success)
            success(friendlyRequests);
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}


+ (void)acceptRequestId:(NSString*)requestId
                success:(void(^)())success
                failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kFriendlyRequestAcceptPath, requestId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)declineRequestId:(NSString*)requestId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kFriendlyRequestDeclinePath, requestId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)inviteFriendsWithId:(NSString*)friendsId
                    message:(NSString*)message
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kInviteUserPath, friendsId];
    [NetworkManager POST_Path:path parameters:@{@"request_message" : [NSObject bs_safeString:message]} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)removeUserFromPotentialFriendWithUserId:(NSString*)userId
                                        success:(void(^)())success
                                        failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kRemoveFromPotentialFriendsPath, userId];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        if (failure)
            success();
    } failure:^(NSError *error) {
        if (success)
            failure(error);
    }];
}

+ (void) getInvitesToEventsForMeWithSuccess:(void (^)(FRInviteModels *inviteModels))success
                                    failure:(void (^)(NSError *error))failure
{
    [NetworkManager GET_Path:kInviteToEventsForMe parameters:@{} success:^(id response) {
    NSError *error;
    FRInviteModels* models = [[FRInviteModels alloc] initWithDictionary:response error:&error];
    if (error)
    {
        if (failure)
            failure(error);
    return;
    }
        if (success)
            success(models);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) blockUserWithId:(NSString*)userId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure
{
    [NetworkManager POST_Path:kBlockUserPath parameters:@{@"user_id" : [NSObject bs_safeString:userId]} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void) reportUserWithId:(NSString*)userId
                  success:(void(^)())success
                  failure:(void(^)(NSError* error))failure
{
    [NetworkManager POST_Path:kReportUserPath parameters:@{@"user_id" : [NSObject bs_safeString:userId]} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];

}

+ (void) removeUserWithId:(NSString*)userId
                  success:(void(^)())success
                  failure:(void(^)(NSError* error))failure
{
    
    NSString* path = [NSString stringWithFormat:@"%@%@",kRemoveUserPath, userId];
    [NetworkManager DELETE_Path:path parameters:@{} success:^(id response) {
        
        UserEntity* userForDelete = [UserEntity  MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId] inContext:[NSManagedObjectContext MR_defaultContext]];

        CurrentUser* currentUser = [[FRUserManager sharedInstance] currentUser];
        [currentUser removeFriendsObject:userForDelete];
        
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
        
        if (success)
            success();
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
    
}



@end
