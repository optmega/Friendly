//
//  FREventPreviewEventViewCellViewModel.m
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewEventViewCellViewModel.h"
#import "FRDateManager.h"

@implementation FREventPreviewEventViewCellViewModel

+ (instancetype) initWithModel:(FREvent*)model
{
    FREventPreviewEventViewCellViewModel* viewModel = [FREventPreviewEventViewCellViewModel new];
    viewModel.event = model;
    viewModel.title = model.title;
    viewModel.gender = model.gender.stringValue;
    viewModel.users = model.memberUsers.allObjects;
    viewModel.slots = [model.slots integerValue] - model.memberUsers.count;
    viewModel.date =  [FRDateManager toLocalTime:model.event_start];
    viewModel.creatorAvatar = model.creator.userPhoto;
    viewModel.backImage = model.imageUrl;
    viewModel.event_type = model.eventType.stringValue;
    viewModel.request_status = model.requestStatus.stringValue;
    viewModel.partner_hosting = model.partnerHosting;
    viewModel.partner = model.partnerUser;
    viewModel.distance =  [NSString stringWithFormat:@"%.1fKM AWAY",[model.way integerValue]  / 1000.];
    viewModel.partner_is_accepted = model.partnerIsAccepted.stringValue;
    viewModel.creator = model.creator;
    FREvent* modelT = [[NSManagedObjectContext MR_defaultContext] objectWithID:model.objectID];

    MemberUser* createEventUser = [MemberUser MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    createEventUser.firstName = modelT.creator.firstName;
    createEventUser.photo = modelT.creator.userPhoto;
    createEventUser.userId = modelT.creator.user_id;
    
    NSMutableArray* mutableUsers = [NSMutableArray arrayWithObject:createEventUser];
    if ((model.partnerUser)&&([model.partnerIsAccepted isEqual:@1])) {
        
        MemberUser* partnerUser = [[NSManagedObjectContext MR_defaultContext] objectWithID: modelT.partnerUser.objectID];
        if ([partnerUser userId]) {
            
            [mutableUsers addObject: partnerUser];
        }
    }
    
    NSArray* users = [modelT.memberUsers.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];
    
    
    [mutableUsers addObjectsFromArray:users];
    viewModel.users = mutableUsers;

    return viewModel;
}

- (void)selectedClose
{
    [self.delegate selectedClose];
}

- (NSString*)distance
{
    //    NSString* way = [self.model.way integerValue] < 1000 ? [NSString stringWithFormat:@"%ldM", (long)[self.model.way integerValue]] : [NSString stringWithFormat:@"%.1fKM", [self.model.way integerValue] / 1000.];
    //
    //    return [NSString stringWithFormat:@"%@ AWAY",way];
    
    return [NSString stringWithFormat:@"%.1fKM AWAY",[self.event.way integerValue]  / 1000.];
}



@end
