//
//  FRAddCollectionViewCell.m
//  Friendly
//
//  Created by Sergey on 09.10.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAddCollectionViewCell.h"

@interface FRAddCollectionViewCell ()


@end

@implementation FRAddCollectionViewCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.image.backgroundColor = [UIColor grayColor];
    self.nameLabel.text = @"Add";
}

- (UIImageView*)image
{
    if (!_image)
    {
        _image = [UIImageView new];
//        _image.layer.cornerRadius = 30;
//        _image.clipsToBounds = YES;
        _image.userInteractionEnabled = YES;
//        _image.layer.borderColor = [[UIColor bs_colorWithHexString:kSeparatorColor] CGColor];
//        _image.layer.borderWidth = 1;
        _image.clipsToBounds = false;
        [self.contentView addSubview:_image];
        
       
        
        
//        UITapGestureRecognizer *singleTap =  [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserProfile)];
//        [singleTap setNumberOfTapsRequired:1];
//        [_image addGestureRecognizer:singleTap];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.width.equalTo(@60);
            make.centerX.equalTo(self.contentView);
        }];
        
    }
    return _image;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

@end
