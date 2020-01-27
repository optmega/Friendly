//
//  InstagramImage+Create.m
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "InstagramImage+Create.h"

@implementation InstagramImage (Create)

+ (instancetype) initWithModel:(NSString*)url inContext:(NSManagedObjectContext *)context
{
    InstagramImage* model = [InstagramImage MR_createEntityInContext:context];
    model.url = url;
    return model;
}

- (NSString*)image
{
    return self.url;
}

@end
