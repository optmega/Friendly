//
//  FRMyEventGuestViewModel.h
//  Friendly
//
//  Created by Jane Doe on 3/29/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FREventModel.h"

@interface FRMyEventGuestViewModel : NSObject

+ (instancetype) initWithModel:(FREventModel*)model;

@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) NSString* eventId;

@end
