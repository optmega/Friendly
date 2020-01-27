//
//  FRPrivateRoomHeaderView.m
//  Friendly
//
//  Created by Sergey on 27.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomHeaderView.h"
#import "UIImageView+WebCache.h"
#import "FRDateManager.h"
#import "FRStyleKit.h"

@implementation FRPrivateRoomHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = 30;
    self.userImage.clipsToBounds = true;
    self.nameLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
}

- (void)updateWithUserEntity:(UserEntity*)userEntity {
 
    userEntity = [[NSManagedObjectContext MR_defaultContext] objectWithID:userEntity.objectID];
    
    self.sinceDateLabel.text = userEntity.friends_since != nil ? [NSString stringWithFormat:@"Friends since %@", [FRDateManager dateStringFromDate:userEntity.friends_since withFormat:@"MM/dd/yyyy"]] : @"";
    
    
    self.nameLabel.text = userEntity.firstName;
    if (userEntity.birthday) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@, %ld", userEntity.firstName, (long)[FRDateManager userYearFromBirthdayDate:userEntity.birthday]];
    }
    
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:userEntity.userPhoto]] placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    
}


@end
