//
//  FRBadgeCountManager.m
//  Friendly
//
//  Created by Jane Doe on 5/17/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBadgeCountManager.h"
#import "FREventTransport.h"
#import "FRFriendsTransport.h"
#import "FREventModel.h"
#import "FRInviteModel.h"
#import "FRFriendsListModel.h"
#import "FRSettingsTransport.h"

@interface FRBadgeCountManager()

@property (nonatomic, assign) NSInteger counter;

@end

@implementation FRBadgeCountManager

- (void) getEventRequestCount:(void(^)(NSInteger count))count
{
//    [FREventTransport getHostingEventWithSuccess:^(NSArray<FREvent*>* events) {
//        NSArray* eventsArray = events;
////        NSInteger counter = 0;
//        FREvent* model = nil;
//        for (int i = 0; i<eventsArray.count; i++)
//        {
//            model = eventsArray[i];
//            if (model.userRequest.count>0)
//            {
//                self.counter+=model.userRequest.allObjects.count;
//            }
//        }
//         [FRFriendsTransport getInvitesToEventsForMeWithSuccess:^(FRInviteModels *inviteModels) {
//                self.counter+=inviteModels.invites.count;
//                self.counter+=inviteModels.invites_to_partner.count;
//                
//                count(self.counter);
//            } failure:^(NSError *error) {
//                //
//            }];
//         }
//     failure:^(NSError *error) {
//      //
//     }];
//
  [FRSettingsTransport getCounter:^(NSString *counter) {
      self.counter = [counter integerValue];
      count(self.counter);
      
  } failure:^(NSError *error) {
      //
  }];
}

+ (void)getFriendsRequest:(void(^)(NSInteger count))success
                  failure:(void(^)(NSError* error))failure
{
    
    [FRFriendsTransport getFriendlyRequestsWithSuccess:^(FRFriendlyRequestsModel *requests) {
        
        success(requests.friendly_requests.count);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
    
}
@end
