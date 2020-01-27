//
//  FRNetworkManager.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AFNetworking.h"
#define NetworkManager [FRNetworkManager shared]

@interface FRNetworkManager : NSObject

@property (nonatomic, readonly, strong) AFHTTPRequestOperationManager* operationManager;

+ (instancetype)shared;

- (void)POST_Path:(NSString*)path
       parameters:(NSDictionary*)parameters
          success:(void(^)(id response))success
          failure:(void(^)(NSError* error))failure;


- (void)GET_Path:(NSString*)path
       parameters:(NSDictionary*)parameters
          success:(void(^)(id response))success
          failure:(void(^)(NSError* error))failure;

- (void)PUT_Path:(NSString*)path
      parameters:(NSDictionary*)parameters
         success:(void(^)(id response))success
         failure:(void(^)(NSError* error))failure;


- (void)DELETE_Path:(NSString*)path
         parameters:(NSDictionary*)parameters
            success:(void(^)(id response))success
            failure:(void(^)(NSError* error))failure;

- (RACSignal*)networkReachabilityStatusSignal;

@end
