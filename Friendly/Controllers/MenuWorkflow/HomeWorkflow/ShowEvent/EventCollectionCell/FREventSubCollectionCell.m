//
//  FREventSubCollectionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 16.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventSubCollectionCell.h"
#import "FRDistanceLabel.h"

@implementation FREventSubCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.titleLabel.font = FONT_VENTURE_EDDING_BOLD(36);
        self.userImage.layer.cornerRadius = 20;
        [self.userImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.top.equalTo(self.eventImage).offset(10);
        }];
        
        [self.shareButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
        }];
        
        [self.distanceLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.eventImage).offset(-15);
            
            CGFloat width = [UIScreen mainScreen].bounds.size.width - 175;
            make.width.lessThanOrEqualTo(@(width));
        }];
        
        
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userImage.mas_bottom).offset(3);
            make.bottom.equalTo(self.distanceLabel.mas_top).offset(0);
        }];
        
        
    }
    return self;
}


@end
