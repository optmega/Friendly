//
//  FRFriendsTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "CurrentUser.h"

@class FRFriendsListModel, FRFriendlyRequestsModel, FRUserModel, FRInviteModels, FRCandidatesListModel;

@interface FRFriendsTransport : NSObject


+ (void)getMyFriendsListWithSuccess:(void(^)(FRFriendsListModel* friendsList))success
                            failure:(void(^)(NSError* error))failure;

+ (void)getCandidatesListWithEvent:(NSString*)eventId
                              page:(NSNumber*)page
                           success:(void(^)(FRCandidatesListModel* friendsList, NSString* pageCount))success
                           failure:(void(^)(NSError* error))failure;

+ (void)getFriendlyRequestsWithSuccess:(void(^)(FRFriendlyRequestsModel* requests))success
                               failure:(void(^)(NSError* error))failure;

+ (void)acceptRequestId:(NSString*)requestId
                success:(void(^)())success
                failure:(void(^)(NSError* error))failure;


+ (void)declineRequestId:(NSString*)requestId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure;
                 
+ (void)inviteFriendsWithId:(NSString*)friendsId
                    message:(NSString*)message
                    success:(void(^)())success
                    failure:(void(^)(NSError* error))failure;

+ (void)removeUserFromPotentialFriendWithUserId:(NSString*)userId
                                        success:(void(^)())success
                                        failure:(void(^)(NSError* error))failure;

+ (void) getInvitesToEventsForMeWithSuccess:(void(^)(FRInviteModels* inviteModels))success
                                            failure:(void(^)(NSError* error))failure;

+ (void) blockUserWithId:(NSString*)userId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure;

+ (void) reportUserWithId:(NSString*)userId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure;

+ (void) removeUserWithId:(NSString*)userId
                 success:(void(^)())success
                 failure:(void(^)(NSError* error))failure;

+ (void)getAvailableForMeetFriendsPage:(NSInteger)page
                               success:(void(^)(FRFriendsListModel* friendsList))success
                               failure:(void(^)(NSError* error))failure;

+ (void)getMyFriendsListPage:(NSInteger)page
                     success:(void(^)(FRFriendsListModel* friendsList))success
                     failure:(void(^)(NSError* error))failure;


@end
