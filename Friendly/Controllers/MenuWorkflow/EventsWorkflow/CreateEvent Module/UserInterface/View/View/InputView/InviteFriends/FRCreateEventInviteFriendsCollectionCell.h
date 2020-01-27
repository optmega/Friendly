//
//  FRCreateEventInviteFriendsCollectionCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRUserModel.h"

@protocol FRInviteFriendsCollectionCellDelegate <NSObject>

- (void) updateFrame:(BOOL)isSomethingChecked;

@end

@interface FRCreateEventInviteFriendsCollectionCell : UICollectionViewCell

- (void) updateCellWithCheckedView;
- (void) updateWithModel:(FRUserModel*)model;

@property (strong, nonatomic) UIImageView* checkedView;
@property (weak, nonatomic) NSObject<FRInviteFriendsCollectionCellDelegate>* delegate;
@property BOOL isChecked;

@end
