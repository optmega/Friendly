//
//  FREventPreviewInfoCellViewModel.m
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewInfoCellViewModel.h"
#import "FRStyleKit.h"
#import "FRDateManager.h"
#import "FREvent.h"

@implementation FREventPreviewInfoCellViewModel

+ (instancetype) initWithModel:(FREvent*)model type:(FRInfoCellViewModelType)type
{
    FREventPreviewInfoCellViewModel* viewModel = [FREventPreviewInfoCellViewModel new];
    
    switch (type) {
        case FRInfoCellViewModelTypeWhere:
        {
            viewModel.title = @"Where";
            viewModel.subtitle = @"Hidden";
            viewModel.icon = [FRStyleKit imageOfEventPreviewLocationIcon];
        }
            break;
        case FRInfoCellViewModelTypeTime:
        {
//            NSDate* dateTime = [FRDateManager dateFromServerWithString:model.event_start];
            viewModel.subtitle = @"Hidden";
            viewModel.title = @"Meet time";
            viewModel.icon = [FRStyleKit imageOfEventPreviewTime];
        }
            break;
        case FRInfoCellViewModelTypeHostsNumber:
        {
            if ((model.requestStatus.integerValue == 2)||([model.creator.user_id isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].currentUser.user_id]])
                                                          ||
                                                          (([model.partnerHosting isEqualToString:[NSString stringWithFormat:@"%@", [FRUserManager sharedInstance].currentUser.user_id]]&&([model.partnerIsAccepted isEqual:@1]))))
            {
            viewModel.title = @"Hosts number";
            viewModel.subtitle = model.creator.mobileNumber;
            }
            else
            {
            viewModel.title = @"Hosts number";
            viewModel.subtitle = @"Hidden";
            }
            if ([model.creator.mobileNumber isEqualToString:@""])
            {
                viewModel.subtitle = @"";
            }
            viewModel.icon = [FRStyleKit imageOfPhoneNumberIcon];

        }
            break;
        case FRInfoCellViewModelTypeOpen:
        {
            viewModel.title = @"Open to friends";
            if (!model.openToFBFriends)
            {
                viewModel.subtitle = @"No";
            }
            else
            {
                viewModel.subtitle = @"Yes";
            }
            viewModel.icon = [FRStyleKit imageOfFeildFacebookCanvas];
        }
            break;
        default:
            break;
    }
    
    
    return viewModel;
}
@end
