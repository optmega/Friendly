//
//  FRChatTransport.h
//  Friendly
//
//  Created by Dmitry on 03.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRRoomModel, FRChatRooms;

@interface FRChatTransport : NSObject

+ (void)createRoomForUserId:(NSString*)userId
                    success:(void(^)(FRRoomModel* room, NSArray* messages))success
                    failure:(void(^)(NSError* error))failure;

+ (void)getAllRooms:(void(^)(FRChatRooms* rooms))success
            failure:(void(^)(NSError* error))failure;

+ (void)getMessageForRoom:(NSString*)roomId
                  success:(void(^)(id result))success
                  failure:(void(^)(NSError* error))failure;

+ (void)getRoomsForPage:(NSInteger)page
                success:(void(^)(FRChatRooms* rooms))success
                failure:(void(^)(NSError* error))failure;

+ (void)getMessageForRoom:(NSString *)roomId
                  forPage:(NSInteger)page
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure;

+ (void)getMessageForEvent:(NSString *)eventId
                   forPage:(NSInteger)page
                   success:(void (^)(id))success
                   failure:(void (^)(NSError *))failure;
@end
