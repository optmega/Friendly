
//
//  FRUploadImage.h
//  Friendly
//
//  Created by Sergey Borichev on 16.04.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "AWSS3.h"

@interface FRUploadImage : NSOperation

@property (nonatomic, strong) NSURL* file;
@property (nonatomic, strong) NSURL* thumb;

@property (nonatomic, copy) void (^success)(NSString *fileLink, NSString* thumbLink);
@property (nonatomic, copy) void (^failure)(NSError *error);
@property (nonatomic, strong) NSString* backet;


+ (NSString*) compressingImage:(UIImage*) image
                withTargetSize:(CGSize)targetSize
                      andNamed:(NSString*)name;


+ (void)uploadImage:(UIImage*)image
           complite:(void(^)(NSString* imageUrl))complite
            failute:(void(^)(NSError* error))failure;

+ (void)uploadImage:(UIImage*)image
               size:(CGSize)size
           complite:(void(^)(NSString* imageUrl))complite
            failute:(void(^)(NSError* error))failure;

+ (UIImage *)image:(UIImage*)image quality:(double)quality;

@end

