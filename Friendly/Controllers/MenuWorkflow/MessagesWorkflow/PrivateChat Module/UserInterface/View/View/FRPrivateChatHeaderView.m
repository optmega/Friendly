//
//  FRPrivateChatHeaderView.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatHeaderView.h"
#import "UIImageHelper.h"
#import "FRStyleKit.h"


@interface FRPrivateChatHeaderView ()

@property (nonatomic, strong) UIView* separator;

@end

@implementation FRPrivateChatHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self separator];
    }
    return self;
}

#pragma mark - LazyLoad

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:kPurpleColor]];
        [_backButton setImage:image forState:UIControlStateNormal];
        [self addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.left.bottom.equalTo(self);
        }];
    }
    return _backButton;
}

- (UIImageView*)photoImage
{
    if (!_photoImage)
    {
        _photoImage = [UIImageView new];
        _photoImage.layer.cornerRadius = 15;
        [self addSubview:_photoImage];
        [_photoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@30);
            make.centerY.equalTo(self.backButton);
            make.right.equalTo(self.mas_centerX).offset(-20);
        }];
    }
    return _photoImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.photoImage);
            make.left.equalTo(self.photoImage.mas_right).offset(5);
            make.width.lessThanOrEqualTo(@100);
        }];
    }
    return _titleLabel;
}


- (UIButton*)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [UIButton new];
        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfFeildMoreOptionsCanvas] color:[UIColor bs_colorWithHexString:kPurpleColor]];
        [_rightButton setImage:image forState:UIControlStateNormal];
        
        [self addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.right.bottom.equalTo(self);
        }];
    }
    return _rightButton;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}


@end
