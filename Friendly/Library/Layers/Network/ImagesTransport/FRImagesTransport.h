//
//  FRImagesTransport.h
//  Friendly
//
//  Created by Jane Doe on 5/19/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRGalleryModel, FRPictureModel;

@interface FRImagesTransport : NSObject

+ (void)searchImagesByCategory:(NSString*)category
                    success:(void(^)(FRGalleryModel* model))success
                    failure:(void(^)(NSError* error))failure;

@end
