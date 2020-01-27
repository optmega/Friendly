//
//  FREventPreviewAttendingCollectionCell.h
//  Friendly
//
//  Created by Jane Doe on 3/10/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventModel.h"

@protocol FREventPreviewAttendingCollectionCellDelegate <NSObject>

-(void)showUserProfile:(NSString*)userId;

@end

@interface FREventPreviewAttendingCollectionCell : UICollectionViewCell

- (void) updateWithModel:(FRJoinUser*)model;
@property (weak, nonatomic) id<FREventPreviewAttendingCollectionCellDelegate> delegate;

@end
