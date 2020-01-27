//
//  FREventFilterSliderCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterSliderCell.h"

@interface FREventFilterSliderCell ()



@end

@implementation FREventFilterSliderCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
    }
    return self;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return _titleLabel;
}

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _contentLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        [self.contentView addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-40);
            make.top.equalTo(self.contentView).offset(15);
        }];
    }
    return _contentLabel;
}

- (NMRangeSlider*)slider
{
    if (!_slider)
    {
        _slider = [NMRangeSlider new];
        [self.contentView addSubview:_slider];
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(15);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.height.equalTo(@50);
        }];
    }
    return _slider;
}


@end
