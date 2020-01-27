//
//  FRAuthTransportService.m
//  Friendly
//
//  Created by Sergey Borichev on 26.02.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAuthTransportService.h"
#import "FRNetworkManager.h"
#import "FRUserModel.h"
#import "FRUserManager.h"

static const struct
{
    __unsafe_unretained NSString *facebookToken;
    __unsafe_unretained NSString *apnsToken;
 
} FRAuthServerParameter =
{
    .facebookToken       = @"facebook_token",
    .apnsToken           = @"apns_token",
};

static NSString* const kAuthPath = @"user/login";
static NSString* const kLogOut   = @"user/logout";

@implementation FRAuthTransportService

+ (void)authWithFacebookToken:(NSString*)facebookToken
                    apnsToken:(NSString*)apnsToken
                      success:(void(^)(FRUserModel* userModel))success
                      failure:(void(^)(NSError* error))failure
{
    NSDictionary* parameters = @{
                                 FRAuthServerParameter.facebookToken : [NSObject bs_safeString:facebookToken],
                                     FRAuthServerParameter.apnsToken : [NSObject bs_safeString: apnsToken]
                                 };
    
    [NetworkManager PUT_Path:kAuthPath parameters:parameters success:^(id response) {
        NSError* error;
        FRUserModel* userModel = [[FRUserModel alloc] initWithDictionary:response[@"user"] error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return;
        }
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull context) {
            
            [CurrentUser initWithUserModel:userModel inContext:context];
        }];
                
        [FRUserManager sharedInstance].userModel = userModel;
        if (success)
            success(userModel);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)logoutSuccess:(void(^)())success
              failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kLogOut parameters:@{} success:^(id response) {
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

@end
