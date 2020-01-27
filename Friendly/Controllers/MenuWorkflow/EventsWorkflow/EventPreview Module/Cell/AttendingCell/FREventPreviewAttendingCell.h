//
//  FRAttendingTableViewCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSTableViewCell.h"
#import "FREventPreviewAttendingViewModel.h"

@protocol FREventPreviewAttendingCellDelegate <NSObject>

-(void)attendingUserTaped:(NSString*)userId;

@end

@interface FREventPreviewAttendingCell : BSTableViewCell

- (void) updateWithModel:(FREventPreviewAttendingViewModel*)model;
@property (weak, nonatomic) id<FREventPreviewAttendingCellDelegate> delegate;

@end
