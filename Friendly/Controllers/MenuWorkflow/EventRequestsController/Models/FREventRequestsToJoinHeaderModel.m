//
//  FREventRequestsToJoinModel.m
//  Friendly
//
//  Created by Jane Doe on 4/7/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsToJoinHeaderModel.h"

@implementation FREventRequestsToJoinHeaderModel

+ (instancetype) initWithModel:(FREvent*)model;
{
    FREventRequestsToJoinHeaderModel* viewModel = [FREventRequestsToJoinHeaderModel new];
    
    viewModel.eventTitle = model.title;
    viewModel.date = model.event_start;
    //viewModel.backImage = model.image_url;
    viewModel.eventId = model.eventId;
    viewModel.event = model;
    return viewModel;
}

@end
