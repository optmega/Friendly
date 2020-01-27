
//
//  FRUploadImage.m
//  Friendly
//
//  Created by Sergey Borichev on 16.04.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUploadImage.h"
#import "AWSS3Manager.h"
#import "AWSS3.h"
#import "FRUserManager.h"

@interface FRUploadImage()

@property (nonatomic, strong) NSString* fileURL;
@property (nonatomic, strong) NSString* thumbURL;
@property (nonatomic, assign) NSInteger numberOfFiles;

@property (nonatomic, assign) BOOL isExecuting;
@property (nonatomic, assign) BOOL isFinished;
@property (nonatomic, assign) BOOL isCancelled;



@end

@implementation FRUploadImage
{
BOOL _isExecuting;
BOOL _isFinished;
BOOL _isCancelled;
}

@synthesize isExecuting = _isExecuting;
@synthesize isFinished = _isFinished;
@synthesize isCancelled = _isCancelled;


+ (void)uploadImage:(UIImage*)image
               size:(CGSize)size
           complite:(void(^)(NSString* imageUrl))complite
            failute:(void(^)(NSError* error))failure
{
    CGSize imageSize = size;
    CGSize thumbnailSize = {100 , 100};
    
    NSString* fileName = [NSString stringWithFormat: @"img-%ld.png",
                          (long)[[NSDate new] timeIntervalSince1970]];
    NSString* thumbName = [NSString stringWithFormat: @"thumb-%ld.png",
                           (long)[[NSDate new] timeIntervalSince1970]];
    
    NSString* fileImage = [FRUploadImage compressingImage:image withTargetSize:imageSize andNamed:fileName];
    NSString* fileThumbnail = [FRUploadImage compressingImage:image withTargetSize:thumbnailSize andNamed:thumbName];
    
    AWSS3Manager* awsManager = [AWSS3Manager shared];
    
    [awsManager uploadImageWithPath:[NSURL fileURLWithPath:fileImage]
                      thumbnailPath:[NSURL fileURLWithPath:fileThumbnail]
                       successBlock:^(NSString *fileLink, NSString *thumbLink) {
                           
                           complite(fileLink);
                           
                       } failureBlock:^(NSError *error) {
                           
                           failure(error);
                           
                       }];

}

+ (void)uploadImage:(UIImage*)image
           complite:(void(^)(NSString* imageUrl))complite
            failute:(void(^)(NSError* error))failure
{
    
    [self uploadImage:image size:image.size complite:complite failute:failure];
}

+ (UIImage*)image:(UIImage *)image quality:(double)quality
{
    NSData *dataForPNGFile = UIImageJPEGRepresentation(image, quality);
    return [UIImage imageWithData:dataForPNGFile];
}


#pragma mark Lifecycle

- (BOOL)isConcurrent
{
    return NO;
}

- (void) start
{
    [self willChangeValueForKey:@"isExecuting"];
    _isExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    
    if (_isCancelled == YES)
    {
        NSLog(@"** OPERATION CANCELED **");
    }
    else
    {
        NSLog(@"Operation started.");
        [self executeOperation];
    }
}

- (void) finish
{
    NSLog(@"operationfinished.");
    
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    
    _isExecuting = NO;
    _isFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
    
    if (_isCancelled == YES)
    {
        NSLog(@"** OPERATION CANCELED **");
    }
}

- (void) cancel
{
    [self willChangeValueForKey:@"isCancelled"];
    _isCancelled = YES;
    [self didChangeValueForKey:@"isCancelled"];
}

- (void) executeOperation
{
    [self createRequest];
}



- (void) createRequest{
    self.numberOfFiles = 2;
    
    NSString* fileName = [NSString stringWithFormat: @"%@-%ld.png",
                          [FRUserManager sharedInstance].userModel.id,
                          (long)[[NSDate new] timeIntervalSince1970]];
    
    AWSS3TransferManagerUploadRequest *uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = self.file;
    uploadRequest.bucket = self.backet;
    uploadRequest.key = fileName;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.contentType = @"image/png";
    
    
    self.fileURL = [NSString stringWithFormat: @"https://s3-us-west-2.amazonaws.com/%@/%@", self.backet, fileName];
    
    [self upload:uploadRequest];
    
    fileName = [NSString stringWithFormat: @"%@-%ld-thumb.png",
                [FRUserManager sharedInstance].userModel.id,
                (long)[[NSDate new] timeIntervalSince1970]];
    
    uploadRequest = [AWSS3TransferManagerUploadRequest new];
    uploadRequest.body = self.thumb;
    uploadRequest.bucket = self.backet;
    uploadRequest.key = fileName;
    uploadRequest.ACL = AWSS3ObjectCannedACLPublicRead;
    uploadRequest.contentType = @"image/png";
    
    
    self.thumbURL = [NSString stringWithFormat: @"https://s3-us-west-2.amazonaws.com/%@/%@", self.backet, fileName];
    
    [self upload:uploadRequest];
    
   
}


- (void) upload:(AWSS3TransferManagerUploadRequest *)uploadRequest {
    
    AWSS3TransferManager *transferManager = [AWSS3TransferManager defaultS3TransferManager];
    __weak FRUploadImage* weakSelf = self;
    

  
    uploadRequest.uploadProgress = ^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
        int progress = (int)(totalBytesSent * 100.0 / totalBytesExpectedToSend);
        
        if (progress > 85) {
            return;
        }
        BSDispatchBlockToMainQueue(^{
    
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UploadImageProgress" object:@(progress) userInfo:nil];
            NSLog(@"%d", progress);
        });
    };
    

    
    [[transferManager upload:uploadRequest] continueWithBlock:^id(AWSTask *task) {
        
        if(!weakSelf)
            return nil;
        
        if (task.error) {
            if ([task.error.domain isEqualToString:AWSS3TransferManagerErrorDomain]) {
                switch (task.error.code) {
                    case AWSS3TransferManagerErrorCancelled:
                    case AWSS3TransferManagerErrorPaused:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                        });
                        
                    }
                        break;
                        
                    default:
                        weakSelf.failure(
                                     
                                     [NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
                                        [weakSelf finish];
                        NSLog(@"Upload failed: [%@]", task.error);
                        break;
                }
            } else {
                                [weakSelf finish];
                weakSelf.failure([NSError errorWithDomain:@"File Server Error" code:-3 userInfo:@{NSLocalizedDescriptionKey:@"Please try again later"}]);
                
                NSLog(@"Upload failed: [%@]", task.error);
            }
        }
        
        if (task.result) {
            weakSelf.numberOfFiles -= 1;
            if(weakSelf.numberOfFiles < 1){
                    weakSelf.success(weakSelf.fileURL, weakSelf.thumbURL);
                [weakSelf finish];
            }
            
        }
        
        return nil;
    }];
    
}


+ (NSString*) compressingImage:(UIImage*) image
                withTargetSize:(CGSize)targetSize
                      andNamed:(NSString*)name
{
    UIImage *sourceImage = image;
    
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
//    if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
//        
//        // CGFloat widthFactor = targetWidth / width;
//        CGFloat heightFactor = targetHeight / height;
//        
//        //  if (widthFactor < heightFactor)
//        //   scaleFactor = widthFactor;
//        //else
//        scaleFactor = heightFactor;
//        
//        scaledWidth  = width * scaleFactor;
//        scaledHeight = height * scaleFactor;
//        
//        // center the image
//        
//        //  if (widthFactor < heightFactor) {
//        //    thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
//        //} else if (widthFactor > heightFactor) {
//        thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
//        //}
//    }
//    
    
    // this is actually the interesting part:
    
    UIGraphicsBeginImageContext(targetSize);
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [image drawInRect:thumbnailRect];
    
    UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    NSData *imageData =  UIImagePNGRepresentation(picture1);
    
    
    UIImage *compressedImage = [UIImage imageWithData:imageData];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", name]];
    //    [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];
    [UIImagePNGRepresentation(compressedImage) writeToFile:filePath atomically:YES];
    
    return filePath;
}

@end
