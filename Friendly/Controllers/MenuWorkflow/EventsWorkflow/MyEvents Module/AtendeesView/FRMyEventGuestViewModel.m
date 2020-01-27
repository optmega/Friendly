//
//  FRMyEventGuestViewModel.m
//  Friendly
//
//  Created by Jane Doe on 3/29/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventGuestViewModel.h"

@implementation FRMyEventGuestViewModel


+ (instancetype) initWithModel:(FREventModel*)model
{
    FRMyEventGuestViewModel* viewModel = [FRMyEventGuestViewModel new];
    viewModel.users = model.users;
    viewModel.eventId = model.id;
    return viewModel;
}


@end
