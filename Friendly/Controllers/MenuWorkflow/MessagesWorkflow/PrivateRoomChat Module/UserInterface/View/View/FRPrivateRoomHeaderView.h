//
//  FRPrivateRoomHeaderView.h
//  Friendly
//
//  Created by Sergey on 27.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FRPrivateRoomHeaderView : UICollectionReusableView
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sinceDateLabel;

- (void)updateWithUserEntity:(UserEntity*)userEntity;

@end
