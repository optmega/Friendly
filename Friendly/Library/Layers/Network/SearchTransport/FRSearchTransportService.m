//
//  FRSearchTransportService.m
//  Friendly
//
//  Created by Sergey Borichev on 23.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchTransportService.h"
#import "FRNetworkManager.h"
#import "FRSearchUserModel.h"
#import "FRUserManager.h"

@interface FRSearchTransportService ()

@end

static NSString* const kSearchUsersPath = @"users/search?q=";

@implementation FRSearchTransportService

+ (void)searchUsersWithString:(NSString*)string
                      success:(void(^)(FRSearchUsers* respons))success
                      failure:(void(^)(NSError* error))failure
{
    string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString* path = [NSString stringWithFormat:@"%@%@&access_token=%@", kSearchUsersPath, string, [NSObject bs_safeString:[FRUserManager sharedInstance].instaToken]];
    
    path = [path stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FRSearchUsers* users = [[FRSearchUsers alloc]initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return;
        }
        if (success)
            success(users);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

@end
