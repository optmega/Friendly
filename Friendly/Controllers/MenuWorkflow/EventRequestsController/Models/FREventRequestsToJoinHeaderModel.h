//
//  FREventRequestsToJoinModel.h
//  Friendly
//
//  Created by Jane Doe on 4/7/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventModel.h"

@interface FREventRequestsToJoinHeaderModel : NSObject

+ (instancetype) initWithModel:(FREvent*)model;

@property (strong, nonatomic) NSString* eventTitle;
@property (strong, nonatomic) NSDate* date;
@property (strong, nonatomic) NSString* eventId;
@property (strong, nonatomic) FREvent* event;
@end

