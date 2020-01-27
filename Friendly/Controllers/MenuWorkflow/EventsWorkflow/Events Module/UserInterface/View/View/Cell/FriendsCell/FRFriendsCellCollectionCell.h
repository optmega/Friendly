//
//  FRFriendsCellCollectionCell.h
//  Friendly
//
//  Created by Jane Doe on 4/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRUserModel.h"

@interface FRFriendsCellCollectionCell : UICollectionViewCell

- (void) updateWithModel:(FRUserModel*)model;

@end
