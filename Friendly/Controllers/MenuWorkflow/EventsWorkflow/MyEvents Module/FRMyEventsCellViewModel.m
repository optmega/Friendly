//
//  FRMyEventsCellViewModel.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCellViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"

@implementation FRMyEventsCellViewModel

+ (instancetype) initWithModel:(FREvent*)model type:(FRMyEventsCellType)type
{
    FRMyEventsCellViewModel* viewModel = [FRMyEventsCellViewModel new];
    
    viewModel.eventModel = model;
    viewModel.title = model.title;
    viewModel.gender = model.gender.stringValue;
    viewModel.date = model.event_start;
    viewModel.backImage = model.imageUrl;
    //viewModel.backImage = @"https://i.ytimg.com/vi/eFInQVePxn4/maxresdefault.jpg";
    viewModel.type = type;
    viewModel.distance =  [NSString stringWithFormat:@"%.1fKM AWAY",[model.way integerValue]  / 1000.];
    viewModel.users = model.memberUsers.allObjects;
    viewModel.id = model.eventId;
    viewModel.event_type = model.eventType.stringValue;
    
    return viewModel;
}

- (NSString*)distance
{
    //    NSString* way = [self.model.way integerValue] < 1000 ? [NSString stringWithFormat:@"%ldM", (long)[self.model.way integerValue]] : [NSString stringWithFormat:@"%.1fKM", [self.model.way integerValue] / 1000.];
    //
    //    return [NSString stringWithFormat:@"%@ AWAY",way];
    
    return [NSString stringWithFormat:@"%.1fKM AWAY",[self.eventModel.way integerValue]  / 1000.];
}



@end
