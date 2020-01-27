//
//  FRSocialTransport.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

//#import "FRInstaMediaModel.h"


@interface FRSocialTransport : NSObject

+ (void)getPhotoFromFacebookId:(NSString*)fbId
                       success:(void(^)(NSArray* images))success
                       failure:(void(^)(NSError* error))failure;

//+ (void)getSelfPhotosFromInstagram:(void(^)(NSArray* models))success
//                         failure:(void(^)(NSError* error))failure;

+ (void)signInWithInstagram:(NSString*)token
                    success:(void(^)(NSArray* images))success
                    failure:(void(^)(NSError* error))failure;
@end
