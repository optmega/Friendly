//
//  FREventPreviewAttendingViewModel.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 12.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewAttendingViewModel.h"

@implementation FREventPreviewAttendingViewModel

+ (instancetype) initWithModel:(FREvent*)modelT
{

    FREventPreviewAttendingViewModel* viewModel = [FREventPreviewAttendingViewModel new];

    FREvent* model = [[NSManagedObjectContext MR_defaultContext] objectWithID:modelT.objectID];
    
    MemberUser* createEventUser = [MemberUser MR_createEntityInContext:[NSManagedObjectContext MR_defaultContext]];
    createEventUser.firstName = model.creator.firstName;
    createEventUser.photo = model.creator.userPhoto;
    createEventUser.userId = model.creator.user_id;
    
    NSMutableArray* mutableUsers = [NSMutableArray arrayWithObject:createEventUser];
    if ((model.partnerUser)&&([model.partnerIsAccepted isEqual:@1])) {
        
        MemberUser* partnerUser = [[NSManagedObjectContext MR_defaultContext] objectWithID: model.partnerUser.objectID];
        if ([partnerUser userId]) {
            
            [mutableUsers addObject: partnerUser];
        }
    }
    
    NSArray* users = [model.memberUsers.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];
    
    
    [mutableUsers addObjectsFromArray:users];
    viewModel.users = mutableUsers;
    viewModel.partnerId = model.partnerHosting;
    return viewModel;
}

@end
