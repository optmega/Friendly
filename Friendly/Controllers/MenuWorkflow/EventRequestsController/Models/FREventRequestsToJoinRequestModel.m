//
//  FREventRequestsToJoinRequestModel.m
//  Friendly
//
//  Created by Jane Doe on 4/8/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsToJoinRequestModel.h"
#import "FRDateManager.h"

@class FRRequestsUser;

@implementation FREventRequestsToJoinRequestModel

+ (instancetype) initWithModel:(UserRequest*)model
{
    FREventRequestsToJoinRequestModel* viewModel = [FREventRequestsToJoinRequestModel new];
    viewModel.name = model.firstName;
    viewModel.avatar = model.photo;
    viewModel.message  = model.requestMessage;
    viewModel.datetimeRequest = [FRDateManager dateStringFromDate:model.createdAt withFormat:@"yyyy-MM-dd h:mm a"];
    viewModel.requestId = model.requestId;
    viewModel.model = model;
    NSDate* birthday = model.birthday;
    NSDateComponents* ageComponents = [[NSCalendar currentCalendar]
                                   components:NSCalendarUnitYear 
                                   fromDate:birthday
                                   toDate:[NSDate date]
                                   options:0];
    NSInteger age = [ageComponents year];
    viewModel.age = [NSString stringWithFormat:@"%ld", (long)age];
    
    return viewModel;

}

@end
