//
//  FRBadgeCountManager.h
//  Friendly
//
//  Created by Jane Doe on 5/17/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface FRBadgeCountManager : NSObject

-(void) getEventRequestCount:(void(^)(NSInteger count))count;

+ (void)getFriendsRequest:(void(^)(NSInteger count))success
                  failure:(void(^)(NSError* error))failure;

@end
