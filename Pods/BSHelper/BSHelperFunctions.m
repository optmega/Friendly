//
//  BSHelperFunctions.m
//
//  Created by Sergey Borichev on 30.11.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//

#import "BSHelperFunctions.h"

void BSDispatchCompletionBlockToMainQueue(BSCompletionBlock block, NSError *error)
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (block) block(error);
    });
}

BSCompletionBlock BSMainQueueCompletionFromCompletion(BSCompletionBlock block)
{
    if (!block) return NULL;
    return ^(NSError *error) {
        BSDispatchBlockToMainQueue(^{
           block(error);
        });
    };
}

void BSDispatchBlockToMainQueue(BSCodeBlock block)
{
    if ([NSThread isMainThread])
    {
        if (block) block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (block) block();
        });
    }
}

BSCodeBlock BSMainQueueBlockFromCompletion(BSCodeBlock block)
{
    if (!block) return NULL;
    return ^{
        
        BSDispatchBlockToMainQueue(^{
            block();
        });
    };
}

void BSDispatchBlockAfter(CGFloat time, BSCodeBlock block)
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), block);
}

void BSDispatchBlockToBackgroundQueue(BSCodeBlock block)
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (block) block();
    });
}


#pragma mark - Objects

BOOL BSIsEmpty(id thing)
{
    return ((thing == nil) || ([thing isEqual:[NSNull null]]) ||
            ([thing respondsToSelector:@selector(length)] && [(NSData *)thing length] == 0) ||
            ([thing respondsToSelector:@selector(count)] && [(NSArray *)thing count] == 0));
}

BOOL BSIsEmptyStringByTrimmingWhitespaces(NSString* string)
{
    if (string)
    {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    }
    return ((string == nil) ||
            ([string respondsToSelector:@selector(length)] && [string length] == 0));
}
