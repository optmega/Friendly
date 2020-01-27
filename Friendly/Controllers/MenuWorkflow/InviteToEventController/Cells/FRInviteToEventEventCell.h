//
//  FRInviteToEventEventCell.h
//  Friendly
//
//  Created by User on 29.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventModel.h"

@interface FRInviteToEventEventCell : UITableViewCell

- (void) updateWithModel:(FREventModel*)model;
- (void) updateToLastCell;

@end
