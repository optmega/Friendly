//
//  FRSettingsTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 02.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRInterestsModels, FRRecomendedUserModels, FRInterestsModel, FRUserModel, FRProfileDomainModel, FRSettingModel, FRFilterModel, FREventFilterDomainModel, FRSettingDomainModel;

@interface FRSettingsTransport : NSObject

+ (void)profileWithSuccess:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                   failure:(void(^)(NSError* error))failure;

+ (void)profileFofUserId:(NSString*)userId
                 success:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                 failure:(void(^)(NSError* error))failure;

+ (void)updateProfile:(FRProfileDomainModel*)profile
              success:(void(^)())success
              failure:(void(^)(NSError* error))failure;

+ (void)getAllInterestsWithSuccess:(void(^)(FRInterestsModels* models))success
                           failure:(void(^)(NSError* error))failure;

+ (void)filterSuccess:(void(^)(Filter* respons))success
                 failure:(void(^)(NSError* error))failure;

+ (void)addNewInterestWithTitle:(NSString*)title
                        success:(void(^)(FRInterestsModel* interests))success
                        failure:(void(^)(NSError* error))failure;


+ (void)updateFilterWithGender:(FREventFilterDomainModel*)filterData
                       success:(void(^)(id respons))success
                       failure:(void(^)(NSError* error))failure;


+ (void)getCurrentUserInterestsWithSuccess:(void(^)(FRInterestsModels* models))success
                                   failure:(void(^)(NSError* error))failure;

+ (void)updateCurrentUserFavoritesInterests:(NSArray*)interests
                                    success:(void(^)(FRInterestsModels* models))success
                                    failure:(void(^)(NSError* error))failure;

+ (void)searchInterestsWith:(NSString*)interest
                    success:(void(^)(FRInterestsModels* models))success
                    failure:(void(^)(NSError* error))failure;

+ (void)recomendedUsersWithSuccess:(void(^)(FRRecomendedUserModels *users))success
                           failure:(void(^)(NSError* error))failure;

+ (void)getSettingSuccess:(void(^)(Setting* model))success
                  failure:(void(^)(NSError* error))failure;

+ (void)updateSetting:(FRSettingDomainModel*)settingModel
              success:(void(^)())success
              failure:(void(^)(NSError* error))failure;

+ (void)getAdStatusWithSuccess:(void(^)(BOOL canShow))success
                       failure:(void(^)(NSError* error))failure;

+ (void)getInviteUrl:(void(^)(NSString* url))success
             failure:(void(^)(NSError* error))failure;


+ (void)postInviteReferral:(NSString*)referral
                   success:(void(^)())success
                   failure:(void(^)(NSError* error))failure;

+ (void)invite:(NSString*)str;

+ (UserEntity*)getUserWithId:(NSString*)userId
                     success:(void(^)(UserEntity* userProfile, NSArray* mutualFriends))success
                     failure:(void(^)(NSError* error))failure;

+ (void)getCounter:(void(^)(NSString* counter))success
             failure:(void(^)(NSError* error))failure;

+ (void)changeUserStatus:(NSInteger)isAvailableForMeetup
                 success:(void(^)(void))success
                 failure:(void(^)(NSError* error))failure;

+ (void)addFeatureReference:(NSString*)userId
                    success:(void(^)(void))success
                    failure:(void(^)(NSError* error))failure;

@end
