//
//  PREventPreviewTextCellViewModel.m
//  Friendly
//
//  Created by Jane Doe on 3/11/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewTextCellViewModel.h"

@implementation FREventPreviewTextCellViewModel

+ (instancetype) initWithModel:(FREvent*)model
{
    FREventPreviewTextCellViewModel* viewModel = [FREventPreviewTextCellViewModel new];
    
    viewModel.infoText = model.info;
    
    return viewModel;
}

@end
