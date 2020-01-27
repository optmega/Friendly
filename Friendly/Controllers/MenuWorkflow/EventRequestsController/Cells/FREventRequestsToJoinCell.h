//
//  FREventRequestsToJoinCell.h
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventRequestsToJoinRequestModel.h"

@protocol FREventRequestsToJoinCellDelegate <NSObject>

-(void)reloadData;
-(void)showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FREventRequestsToJoinCell : UITableViewCell

- (void) updateWithModel:(FREventRequestsToJoinRequestModel*)model;
@property (weak, nonatomic) NSObject<FREventRequestsToJoinCellDelegate>* delegate;

@end
