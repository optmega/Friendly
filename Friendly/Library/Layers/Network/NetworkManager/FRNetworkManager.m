//
//  FRNetworkManager.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRNetworkManager.h"
#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "FRSettingInteractor.h"

@interface FRNetworkManager ()

@property (nonatomic, strong) AFHTTPRequestOperationManager* operationManager;

@end

@implementation FRNetworkManager

+ (instancetype)shared
{
    static FRNetworkManager* sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
       
        sharedManager = [[FRNetworkManager alloc]init];
    });
    
    return sharedManager;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
    
        self.operationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL: [NSURL URLWithString: SERVER_URL]];
        self.operationManager.responseSerializer = [AFJSONResponseSerializer serializer];
        self.operationManager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        [self.operationManager.requestSerializer setAuthorizationHeaderFieldWithUsername: SERVER_API_KEY
                                                                            password: SERVER_API_PASS];
    }
    return self;
}


#pragma mark - Methods

- (void)POST_Path:(NSString*)path
       parameters:(NSDictionary*)parameters
          success:(void(^)(id response))success
          failure:(void(^)(NSError* error))failure
{
//    @weakify(self);
//    BSDispatchBlockToBackgroundQueue(^{
//        @strongify(self);
    
        RACSignal* signal = [self.operationManager rac_POST:path parameters:parameters];
        
        [signal subscribeNext:^(RACTuple* tuple) {
            
            [self _responseHandler:tuple success:success failure:failure];
            
        } error:^(NSError *error) {
            
            failure(error);
        }];
//    });
    
}

- (void)GET_Path:(NSString*)path
      parameters:(NSDictionary*)parameters
         success:(void(^)(id response))success
         failure:(void(^)(NSError* error))failure
{
    RACSignal* signal = [self.operationManager rac_GET:path parameters:parameters];
    
    [signal subscribeNext:^(RACTuple* tuple) {
        
        [self _responseHandler:tuple success:success failure:failure];

    } error:^(NSError *error) {
        if ([self errorHandler:error]) {
            return ;
        }
        failure(error);
    }];
}

- (void)PUT_Path:(NSString*)path
      parameters:(NSDictionary*)parameters
         success:(void(^)(id response))success
         failure:(void(^)(NSError* error))failure
{
    RACSignal* signal = [self.operationManager rac_PUT:path parameters:parameters];
    
    [signal subscribeNext:^(RACTuple* tuple) {

        [self _responseHandler:tuple success:success failure:failure];
        
    } error:^(NSError *error) {
    
        if ([self errorHandler:error]) {
            return ;
        }
        NSError* errorWithCode = [NSError errorWithDomain:error.localizedDescription code:error.code userInfo:error.userInfo];
        failure(errorWithCode);
    }];
}

- (void)DELETE_Path:(NSString*)path
         parameters:(NSDictionary*)parameters
            success:(void(^)(id response))success
            failure:(void(^)(NSError* error))failure
{
    RACSignal* signal = [self.operationManager rac_DELETE:path parameters:parameters];
    
    [signal subscribeNext:^(RACTuple* tuple) {
        
        [self _responseHandler:tuple success:success failure:failure];
        
    } error:^(NSError *error) {
        
        if ([self errorHandler:error]) {
            return ;
        }
        NSError* errorWithCode = [NSError errorWithDomain:error.localizedDescription code:error.code userInfo:error.userInfo];
        failure(errorWithCode);
    }];
}

- (void)_responseHandler:(RACTuple*)tuple
                 success:(void(^)(id response))success
                 failure:(void(^)(NSError* error))failure
{
    RACTupleUnpack(AFHTTPRequestOperation *operation, id responseObject) = tuple;
    
    NSLog(@"%@", responseObject);
    [operation response];
    NSInteger statusCode = [responseObject[@"status"] integerValue];
    if (statusCode == 200 || statusCode == 0)
    {
        success(responseObject);
        return;
    }
    
    if (statusCode == 401) {
        
        [FRSettingInteractor logOut:nil];
        return;
    }
    
    NSString* message = responseObject[@"message"] ? responseObject[@"message"] : @"Error";
    failure([NSError errorWithDomain:message code:statusCode userInfo:@{}]);
}

- (BOOL)errorHandler:(NSError*)error {
    
    if ([[[error userInfo] objectForKey:AFNetworkingOperationFailingURLResponseErrorKey] statusCode] == 401 ) {
        
        [FRSettingInteractor logOut:nil];
        
        return true;
    }
    
    return false;

}

- (RACSignal*)networkReachabilityStatusSignal {
    return [self.operationManager networkReachabilityStatusSignal];
}

@end
