//
//  FREventPreviewAttendingSmallCollectionCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 13.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventModel.h"
#import "FRMemberUser.h"

@interface FREventPreviewAttendingSmallCollectionCell : UICollectionViewCell

- (void) updateWithModel:(FRMemberUser*)model;

@end
