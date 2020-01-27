//
//  FRProfileFriendCollectionCell.h
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class MutualUser;


#import "FREventModel.h"

@protocol FRProfileFriendCollectionCellDelegate <NSObject>

-(void)showUserProfile:(NSString*)userId;
-(void)showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FRProfileFriendCollectionCell : UICollectionViewCell

@property (strong, nonatomic) MutualUser* model;
@property (strong, nonatomic) UserEntity* userEntity;

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* faceBookLogoImage;
@property (strong, nonatomic) UIImageView* image;
@property (weak, nonatomic) id<FRProfileFriendCollectionCellDelegate> delegate;

- (void)updateWithModel:(MutualUser*)model;
- (void)updateWithUserEntityModel:(UserEntity*)model;

- (void)addMode;

@end
