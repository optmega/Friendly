//
//  FRSettingsTransport.m
//  Friendly
//
//  Created by Sergey Borichev on 02.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSettingsTransport.h"
#import "FRNetworkManager.h"
#import "FRInterestsModel.h"
#import "FRRecomendedUserModel.h"
#import "FRUserModel.h"
#import "FRProfileDomainModel.h"
#import "FRSettingModel.h"
#import "FREventFilterDomainModel.h"
#import "FRUserManager.h"
#import "FRSettingDomainModel.h"

#import "CurrentUser.h"
#import "Filter.h"
#import "Setting.h"
#import "MutualUser.h"

static NSString* const kProfilePath = @"user";
static NSString* const kFilterPath = @"user/filter";
static NSString* const kUpdateFilterPath = @"user/filter";
static NSString* const kInterestsPath = @"interests";
static NSString* const kAddNewInterestPath = @"interests";
static NSString* const kGetCurrentUserInterestsPath = @"user/interests";
static NSString* const kUpdateCurrentInterestsPath = @"user/interests";
static NSString* const kSearchInterestsPath = @"search/interests?query=";
static NSString* const kRecomendedUsers = @"users/recommended";
static NSString* const kUpdateProfilePath = @"user";
static NSString* const kSettingPath = @"user/settings";
static NSString* const kUpdateSettitgPath = @"user/settings";
static NSString* const kAdPath = @"settings/ads";
static NSString* const kReferralsUrlPath = @"fb/u/referral/url";
static NSString* const kReferralsPath = @"fb/u/referrals";
static NSString* const kCounterPath = @"counter";
static NSString* const kChangeAvailableForMeet = @"user/status";
static NSString* const kInviteUser = @"events/featured/enable";


@implementation FRSettingsTransport


+ (void)profileFofUserId:(NSString*)userId
                 success:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                 failure:(void(^)(NSError* error))failure
{
    if (!userId) {
        return;
    }
    
    NSString* path = [NSString stringWithFormat:@"%@?instagram_token=%@",[kProfilePath copy],[[NSUserDefaults standardUserDefaults] objectForKey:@"instaToken"]];

    
    if (userId)
    {
        path = [NSString stringWithFormat:@"%@&id=%@", path, userId];
    }
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        
        NSError* error;
        FRUserModel* userProfile = [[FRUserModel alloc]initWithDictionary:response[@"user"] error:&error];
        
        if(error)
        {
            failure(error);
            return;
        }
        
        userProfile.wall = userProfile.wall ? userProfile.wall : userProfile.cover_image;

        NSMutableArray* mutualUserEntity = [NSMutableArray array];
        __block UserEntity* user;

        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
            if (!userId || [[NSString stringWithFormat:@"%@",userId] isEqualToString:[FRUserManager sharedInstance].currentUser.user_id])
            {
                [FRUserManager sharedInstance].userModel = userProfile;
                user = [CurrentUser initWithUserModel:userProfile inContext:context];
                
            } else {
                
                user = [UserEntity initWithUserModel:userProfile inContext:context];
                
                if (!user.isFriend.boolValue) {
                    [[FRUserManager sharedInstance].currentUser removeFriendsObject:user];
                }
            }
        
        
        [context MR_saveToPersistentStoreAndWait];
            
            if (success)
                success(user, mutualUserEntity);
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];

}


+ (void)profileWithSuccess:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                   failure:(void(^)(NSError* error))failure
{
    [self profileFofUserId:[FRUserManager sharedInstance].currentUser.user_id success:success failure:failure];
}

+ (void)updateProfile:(FRProfileDomainModel*)profile
              success:(void(^)())success
              failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kUpdateProfilePath parameters:[profile domainModelDictionary] success:^(id response) {
       
        
        NSError* error;
        FRUserModel* userProfile = [[FRUserModel alloc]initWithDictionary:response[@"user"] error:&error];
        
        if(error)
        {
            failure(error);
            return;
        }
        
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull context) {

            [FRUserManager sharedInstance].userModel = userProfile;
            [CurrentUser initWithUserModel:userProfile inContext:context];
        }];
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)filterSuccess:(void(^)(Filter* respons))success
                 failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kFilterPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRFilterModel* model = [[FRFilterModel alloc]initWithDictionary:response[@"filter"] error:&error];
        if (error)
        {
            failure(error);
            return;
        }
        [MagicalRecord saveWithBlockAndWait:^(NSManagedObjectContext * _Nonnull context) {

            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            currentUser.filter = [Filter initFilterWith:model inContext:context];
            if (success)
                success(currentUser.filter);
        }];
        
        
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)updateFilterWithGender:(FREventFilterDomainModel*)filterData
                       success:(void(^)(id respons))success
                       failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kUpdateFilterPath parameters:[filterData domainModelDictionary] success:^(id response) {
        
        NSError* error;
        FRFilterModel* model = [[FRFilterModel alloc]initWithDictionary:response[@"filter"] error:&error];
        if (error)
        {
            failure(error);
            return;
        }
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
            
            CurrentUser* currentUser = [localContext objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            currentUser.filter = [Filter initFilterWith:model inContext:localContext];

        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UpdateFilter" object:nil];
        }];
        
        
        
        if (success)
            success([[FRUserManager sharedInstance].currentUser filter]);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)getAllInterestsWithSuccess:(void(^)(FRInterestsModels* models))success
                           failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kInterestsPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRInterestsModels* models = [[FRInterestsModels alloc] initWithDictionary:response error:&error];
        if (error)
        {
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

+ (void)addNewInterestWithTitle:(NSString*)title
                        success:(void(^)(FRInterestsModel* interests))success
                        failure:(void(^)(NSError* error))failure
{
    [NetworkManager POST_Path:kAddNewInterestPath parameters:@{@"title":[NSObject bs_safeString:title]} success:^(id response) {
        
        NSError* error;
        FRInterestsModel* model = [[FRInterestsModel alloc] initWithDictionary:response[@"interest"] error:&error];
        if(error)
        {
            if (failure)
                failure(error);
            return;
        }
        if (success)
            success(model);
    } failure:^(NSError *error) {
        if (success)
            failure(error);
    }];

}

+ (void)getCurrentUserInterestsWithSuccess:(void(^)(FRInterestsModels* models))success
                            failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kGetCurrentUserInterestsPath parameters:@{} success:^(id response) {
        NSError* error;
        FRInterestsModels* models = [[FRInterestsModels alloc]initWithDictionary:response error:&error];
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

+ (void)updateCurrentUserFavoritesInterests:(NSArray*)interests
                                    success:(void(^)(FRInterestsModels* models))success
                                    failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kUpdateCurrentInterestsPath parameters:@{@"interests" : interests} success:^(id response) {
        NSError* error;
        FRInterestsModels* models = [[FRInterestsModels alloc]initWithDictionary:response error:&error];
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

+ (void)searchInterestsWith:(NSString*)interest
                    success:(void(^)(FRInterestsModels* models))success
                    failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@",kSearchInterestsPath, interest];
    [NetworkManager PUT_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FRInterestsModels* models = [[FRInterestsModels alloc]initWithDictionary:response error:&error];
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




+ (void)recomendedUsersWithSuccess:(void(^)(FRRecomendedUserModels *users))success
                           failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kRecomendedUsers parameters:@{} success:^(id response) {
        
        NSError* error;
        FRRecomendedUserModels* models = [[FRRecomendedUserModels alloc]initWithDictionary:response error:&error];
        if(error)
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

+ (void)getSettingSuccess:(void(^)(Setting* model))success
                  failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kSettingPath parameters:@{} success:^(id response) {
        
        NSError* error;
        FRSettingModel* setting = [[FRSettingModel alloc] initWithDictionary:response[@"settings"] error:&error];
        if(error)
        {
            if (failure)
                failure(error);
            return ;
        }
        __block Setting* settingEntity;
        
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        
            settingEntity = [Setting initWithSetting:setting inContext:context];
            CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            currentUser.setting = settingEntity;
            
//        } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
        
        [context MR_saveToPersistentStoreAndWait];
            if (success)
                success(settingEntity);
//        }];
        
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)updateSetting:(FRSettingDomainModel*)settingModel
              success:(void(^)())success
              failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kUpdateSettitgPath parameters:[settingModel domainModelDictionary] success:^(id response) {
        
        NSError* error;
        FRSettingModel* setting = [[FRSettingModel alloc] initWithDictionary:response[@"settings"] error:&error];
        if(error)
        {
            if (failure)
                failure(error);
            return ;
        }
        
        if ([FRUserManager sharedInstance].currentUser) { 
            
            [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull context) {

                Setting* settingEntity = [Setting initWithSetting:setting inContext:context];
                CurrentUser* currentUser = [context objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
                currentUser.setting = settingEntity;
            } completion:^(BOOL contextDidSave, NSError * _Nullable error) {
                
            }];
            
        }
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)getAdStatusWithSuccess:(void(^)(BOOL canShow))success
                       failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kAdPath parameters:@{} success:^(id response) {
        
        NSNumber* canAd = response[@"ads"];
        success(canAd.boolValue);
        
    } failure:^(NSError *error) {
        failure(error);
    }];
}


+ (void)getInviteUrl:(void(^)(NSString* url))success
             failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kReferralsUrlPath parameters:@{} success:^(id response) {
        success(response[@"url"]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)postInviteReferral:(NSString*)referral
                   success:(void(^)())success
                   failure:(void(^)(NSError* error))failure
{
    [NetworkManager POST_Path:kReferralsPath parameters:@{@"referral" : referral} success:^(id response) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)invite:(NSString *)str
{
    [NetworkManager POST_Path:@"invite/html" parameters:nil success:^(id response) {
        
    } failure:^(NSError *error) {
        
    }];
}

+ (UserEntity*)getUserWithId:(NSString*)userId
                     success:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                     failure:(void(^)(NSError* error))failure
{
    
    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@",userId]];
    if (!user)
    {
        [self profileFofUserId:userId success:success failure:failure];
    }
    return user;
}

+ (void)getCounter:(void(^)(NSString* counter))success
           failure:(void(^)(NSError* error))failure
{
    [NetworkManager GET_Path:kCounterPath parameters:@{} success:^(id response) {
        success(response[@"count"]);
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (void)changeUserStatus:(NSInteger)isAvailableForMeetup
                 success:(void(^)(void))success
                 failure:(void(^)(NSError* error))failure
{
    [NetworkManager PUT_Path:kChangeAvailableForMeet parameters:@{@"availability_status" : @(isAvailableForMeetup)} success:^(id response) {
        
//        [MagicalRecord saveWithBlock:^(NSManagedObjectContext * _Nonnull localContext) {
        NSManagedObjectContext* localContext = [NSManagedObjectContext MR_defaultContext];
        
            CurrentUser* user = [localContext objectWithID:[FRUserManager sharedInstance].currentUser.objectID];
            user.availableStatus = @(isAvailableForMeetup);
//            FRUserModel* model = [[FRUserModel alloc] initWithDictionary:response[@"user"] error:nil];
//            [CurrentUser initWithUserModel:model inContext:localContext];
//        }];
        [localContext MR_saveToPersistentStoreAndWait];
        if (success)
            success();
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];
}

+ (void)addFeatureReference:(NSString*)userId
                    success:(void(^)(void))success
                    failure:(void(^)(NSError* error))failure {
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", kInviteUser, userId];
    [NetworkManager GET_Path:path parameters:nil success:^(id response) {
        
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

@end
