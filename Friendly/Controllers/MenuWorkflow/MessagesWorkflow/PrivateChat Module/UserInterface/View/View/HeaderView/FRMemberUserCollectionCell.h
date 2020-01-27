//
//  FRMemberUserCollectionCell.h
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileFriendCollectionCell.h"
#import "FRMemberUser.h"


@interface FRMemberUserCollectionCell : FRProfileFriendCollectionCell

//@property (strong, nonatomic) UILabel* nameLabel;
//@property (strong, nonatomic) UIImageView* faceBookLogoImage;
//@property (strong, nonatomic) UIImageView* image;

- (void)updateWithModel:(UserEntity *)model;

@end
