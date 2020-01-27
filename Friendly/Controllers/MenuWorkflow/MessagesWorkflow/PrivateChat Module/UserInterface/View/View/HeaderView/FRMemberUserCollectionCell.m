//
//  FRMemberUserCollectionCell.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMemberUserCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "MutualUser.h"
#import "FRStyleKit.h"

@implementation FRMemberUserCollectionCell

- (void)updateWithModel:(MutualUser *)model
{
    self.model = model;
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:model.photo]];
    
    [self.image sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
//    [self.image sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//
//        self.image.image = image;
//    }];
    self.nameLabel.text = model.firstName;
    self.faceBookLogoImage.hidden = true;
}


@end
