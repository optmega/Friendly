//
//  FRCategoryTableViewCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FReventPreviewCategoryCellViewModel.h"
#import "FREventModel.h"


@interface FREventPreviewCategoryCell : UITableViewCell

- (void) updateWithModel:(FREventPreviewCategoryCellViewModel*)model countNearbyEvents:(NSString *)count;

@end
