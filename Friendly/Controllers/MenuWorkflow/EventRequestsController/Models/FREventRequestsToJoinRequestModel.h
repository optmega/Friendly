//
//  FREventRequestsToJoinRequestModel.h
//  Friendly
//
//  Created by Jane Doe on 4/8/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FREventTransport.h"
#import "FREventModel.h"

@interface FREventRequestsToJoinRequestModel : NSObject

+ (instancetype) initWithModel:(UserRequest*)model;

@property (strong, nonatomic) NSString* avatar;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* age;
@property (strong, nonatomic) NSString* message;
@property (strong, nonatomic) NSString* datetimeRequest;
@property (strong, nonatomic) NSString* requestId;
@property (strong, nonatomic) UserRequest* model;
@end
