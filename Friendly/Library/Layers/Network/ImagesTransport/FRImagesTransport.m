//
//  FRImagesTransport.m
//  Friendly
//
//  Created by Jane Doe on 5/19/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRImagesTransport.h"
#import "FRNetworkManager.h"
#import "FRGalleryModel.h"


static NSString* const kImagesSearchPath = @"gallery?category=";

@implementation FRImagesTransport

+ (void)searchImagesByCategory:(NSString*)category
                       success:(void(^)(FRGalleryModel* model))success
                       failure:(void(^)(NSError* error))failure
{
    NSString* path = [NSString stringWithFormat:@"%@%@", kImagesSearchPath, category];
    
    [NetworkManager GET_Path:path parameters:@{} success:^(id response) {
        NSError* error;
        FRGalleryModel* model = [[FRGalleryModel alloc]initWithDictionary:response error:&error];
        if (error)
        {
            if (failure)
                failure(error);
            return;
        }
        if (success)
            success(model);
    } failure:^(NSError *error) {
        if (failure)
            failure(error);
    }];

}
@end
