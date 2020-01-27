//
//  FRPrivateChatUserHeader.m
//  Friendly
//
//  Created by Dmitry on 11.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatUserHeader.h"

@interface FRPrivateChatUserHeader ()

@property (nonatomic, strong) UIImageView* userPhoto;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@end

@implementation FRPrivateChatUserHeader

- (void)updateWithModel:(FRPrivateChatUserHeaderViewModel *)model
{
    [model updateImage:self.userPhoto];
    self.titleLabel.attributedText = model.title;
    self.subtitleLabel.text = model.subtitle;
}

- (UIImageView*)userPhoto
{
    if (!_userPhoto)
    {
        _userPhoto = [UIImageView new];
        _userPhoto.layer.cornerRadius = 70;
        _userPhoto.clipsToBounds = YES;
        [self addSubview:_userPhoto];
        [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self);
            make.height.width.equalTo(@140);
        }];
    }
    return _userPhoto;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_REGULAR(20);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:KTextTitleColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(self.userPhoto.mas_bottom).offset(10);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = FONT_PROXIMA_NOVA_REGULAR(14);
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(30);
            make.right.equalTo(self).offset(-30);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
        }];
    }
    return _subtitleLabel;
}

@end
