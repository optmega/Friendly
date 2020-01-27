//
//  FRMyEventsGuestCollectionViewCell.h
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRUserModel.h"
#import "FREventModel.h"

@protocol FRMyEventsGuestCollectionViewCellDelegate <NSObject>

-(void) discardUser:(NSString*)userId forRow:(NSInteger)row;
-(void) showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FRMyEventsGuestCollectionViewCell : UICollectionViewCell

@property (assign, nonatomic) NSInteger rowNumber;
@property (strong, nonatomic) UIButton* checkedView;
@property (weak, nonatomic) NSObject<FRMyEventsGuestCollectionViewCellDelegate>* delegate;

- (void) updateWithModel:(MemberUser*)user andRowSelected:(NSInteger)row;

@end
