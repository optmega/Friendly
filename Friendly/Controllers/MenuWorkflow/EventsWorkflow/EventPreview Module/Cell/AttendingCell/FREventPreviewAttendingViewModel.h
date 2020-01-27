//
//  FREventPreviewAttendingViewModel.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 12.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FREvent.h"

@interface FREventPreviewAttendingViewModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model;

@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) NSString* partnerId;

@end
