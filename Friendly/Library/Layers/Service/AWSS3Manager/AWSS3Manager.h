//
//  AWSS3Manager.h
//  Friendly
//
//  Created by Sergey Borichev on 16.04.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface AWSS3Manager : NSObject

+ (instancetype) shared;

- (NSUInteger) getTaskCount;

- (void) uploadImageWithPath: (NSURL*) url
               thumbnailPath: (NSURL*) thumbURL
                successBlock: (void (^)(NSString *fileLink, NSString* thumbLink)) successBlock
                failureBlock: (void (^)(NSError* error)) failureBlock;


@end
