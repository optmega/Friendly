//
//  InstagramImage+Create.h
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "InstagramImage.h"

@interface InstagramImage (Create)

+ (instancetype) initWithModel:(NSString*)url inContext:(NSManagedObjectContext *)context;
- (NSString*)image;

@end
