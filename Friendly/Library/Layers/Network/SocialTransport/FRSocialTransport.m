//
//  FRSocialTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSocialTransport.h"
#import "FRNetworkManager.h"
#import "FRSettingsTransport.h"

static NSString* const kFacebookImagePath = @"fb/images?facebook_token=";
static NSString* const kSelfMediaInstagramPath = @"https://api.instagram.com/v1/users/self/media/recent/?access_token=";
static NSString* const kInstagramSignPath = @"user/instagram";

@implementation FRSocialTransport

+ (void)getPhotoFromFacebookId:(NSString*)fbId
                       success:(void(^)(NSArray* images))success
                       failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kFacebookImagePath parameters:@{} success:^(id response) {
        
        success(response[@"images"]);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)signInWithInstagram:(NSString*)token
                    success:(void(^)(NSArray* images))success
                    failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kInstagramSignPath parameters:@{@"instagram_token" : [NSObject bs_safeString:token]} success:^(id response) {
        success(response[@"images"]);
        [FRSettingsTransport profileFofUserId:[FRUserManager sharedInstance].currentUser.user_id success:^(UserEntity *userProfile, NSArray *mutualFriends) {
            //
        } failure:^(NSError *error) {
            //
        }];
        
           } failure:^(NSError *error) {
                failure(error);

    }];
}

//+ (void)getSelfPhotosFromInstagram:(void(^)(NSArray* models))success
//                         failure:(void(^)(NSError* error))failure
//{
//    [NetworkManager GET_Path:[NSString stringWithFormat:@"%@%@&count=10",kSelfMediaInstagramPath, kAccessToken] parameters:@{} success:^(id response) {
//        
//         NSError* error;
//        FRInstaMediaModels* requests = [[FRInstaMediaModels alloc]initWithDictionary:response error:&error];
//        NSMutableArray *array = [NSMutableArray new];
//        for (int i = 0; i<requests.data.count; i++)
//        {
//            FRInstaMediaModel* model = [requests.data objectAtIndex:i];
//            NSDictionary *dict = [model.images objectForKey:@"standard_resolution"];
//            [array addObject:[dict objectForKey:@"url"]];
//        }
//
//        if (error)
//        {
//            failure(error);
//            return ;
//        }
//        
////        success(requests);
//        success(array);
//        
//    } failure:^(NSError *error) {
//        failure(error);
//    }];
//
//}

@end
