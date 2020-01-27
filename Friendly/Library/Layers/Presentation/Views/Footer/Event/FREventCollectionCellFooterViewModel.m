//
//  FREventCollectionCellFooterViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventCollectionCellFooterViewModel.h"
#import "FREventModel.h"
#import "FRDateManager.h"
#import "FREvent.h"

@interface FREventCollectionCellFooterViewModel ()

@property (nonatomic, strong) FREvent* model;

@end

@implementation FREventCollectionCellFooterViewModel

+ (instancetype)initWithModel:(FREvent*)eventModel
{
    FREventCollectionCellFooterViewModel* viewModel = [FREventCollectionCellFooterViewModel new];
    viewModel.model = eventModel;
    return viewModel;
}

- (NSArray*)users
{
    
    NSMutableArray* array = [NSMutableArray array];
    
    MemberUser* host = [MemberUser MR_createEntity];
    host.firstName = self.model.creator.firstName;
    host.photo = self.model.creator.userPhoto;
    host.userId = self.model.creator.user_id;
    
    [array addObject:host];
    
    if ([[self.model partnerUser] firstName]&&([self.model.partnerIsAccepted isEqual:@1])) {
        [array addObject:self.model.partnerUser];
    }
    
    [array addObjectsFromArray:self.model.memberUsers.allObjects];
    
    return array;
}

- (NSInteger)openSlots
{
    return [self.model.slots integerValue] - self.model.memberUsers.count;
}

- (NSString*)dayOfWeak
{
//    [FRDateManager dayOfweekFromString:self.model.event_start];
    
    return [[FRDateManager dayOfWeek:self.model.event_start] uppercaseString];
}

- (NSString*)dayOfMonth
{
    return [[FRDateManager dayOfMonth:self.model.event_start] uppercaseString];
}


@end
