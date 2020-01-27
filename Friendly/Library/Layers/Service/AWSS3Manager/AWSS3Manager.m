//
//  AWSS3Manager.m
//  Friendly
//
//  Created by Sergey Borichev on 16.04.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "AWSS3Manager.h"
#import "AWSS3.h"
#import "FRUploadImage.h"

#define ACCESS_KEY_ID @"AKIAIJZ7MUO32KWGBY5A"
#define SECRET_KEY @"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"
#define AMAZON_FILE_BUKET @"friendlyapp-events-images"
#define FULL_FILE_BUCKET  [[NSString stringWithFormat:@"%@-%@", AMAZON_FILE_BUKET, ACCESS_KEY_ID] lowercaseString]


@interface AWSS3Manager()

@property (nonatomic, strong) NSOperationQueue* downloadQueue;

@end

@implementation AWSS3Manager

#pragma mark -
#pragma mark Lifecycle

+ (instancetype) shared
{
    static AWSS3Manager* sharedManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[AWSS3Manager alloc] init];
    });
    return sharedManager;
}

- (instancetype) init
{
    self = [super init];
    if(self)
    {
        
        self.downloadQueue = [[NSOperationQueue alloc] init];
        self.downloadQueue.maxConcurrentOperationCount = 10;
        
                AWSStaticCredentialsProvider *credentialsProvider = [[AWSStaticCredentialsProvider alloc] initWithAccessKey:ACCESS_KEY_ID secretKey: SECRET_KEY];
        AWSServiceConfiguration *configuration = [[AWSServiceConfiguration alloc] initWithRegion: AWSRegionUSWest2 credentialsProvider: credentialsProvider];
        [AWSServiceManager defaultServiceManager].defaultServiceConfiguration = configuration;
        
        NSError *error = nil;
        if (![[NSFileManager defaultManager] createDirectoryAtPath:[NSTemporaryDirectory() stringByAppendingPathComponent:@"upload"]
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"Creating 'upload' directory failed: [%@]", error);
        }
        
    }
    return self;
}


- (NSUInteger) getTaskCount
{
    return self.downloadQueue.operations.count;
}


- (void) uploadImageWithPath: (NSURL*) url
               thumbnailPath: (NSURL*) thumbURL
                successBlock: (void (^)(NSString *fileLink, NSString* thumbLink)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock;

{
    FRUploadImage* operation = [[FRUploadImage alloc] init];
        
    operation.file = url;
    operation.thumb = thumbURL;
    operation.success = successBlock;
    operation.failure = failureBlock;
    operation.backet = AMAZON_FILE_BUKET;
        
    [self.downloadQueue addOperation: operation];
}


@end
