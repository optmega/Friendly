//
//  FRPushHeaderView.m
//  Friendly
//
//  Created by Dmitry on 20.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPushHeaderView.h"

@interface FRPushHeaderView ()

@property (nonatomic, strong) UIImageView* leftIcon;
@property (nonatomic, strong) UILabel* title;
@property (nonatomic, strong) UILabel* subtitle;
@property (nonatomic, strong) UIImageView* rightIcon;


@end

@implementation FRPushHeaderView

- (void)updateViewModel:(FRPushHeaderViewModel*)model
{
    [model setLeftIconImage:self.leftIcon];
    [model setRightIconImage:self.rightIcon];
    self.title.text = model.title;
    self.subtitle.text = model.subtitle;
}


#pragma mark - LazyLoad

- (UIImageView*)leftIcon
{
    if (!_leftIcon)
    {
        _leftIcon = [UIImageView new];
        _leftIcon.layer.cornerRadius = 20;
        _leftIcon.layer.borderColor = [UIColor whiteColor].CGColor;
        _leftIcon.layer.borderWidth = 1;
        _leftIcon.clipsToBounds = YES;
        [self addSubview:_leftIcon];
        [_leftIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@40);
            make.left.equalTo(self).offset(20);
            make.centerY.equalTo(self);
        }];
    }
    return _leftIcon;
}

- (UILabel*)title
{
    if (!_title)
    {
        _title = [UILabel new];
        _title.font = FONT_SF_DISPLAY_MEDIUM(16);
        _title.textColor = [UIColor whiteColor];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right).offset(10);
            make.bottom.equalTo(self.mas_centerY);
            make.right.equalTo(self.rightIcon.mas_left).offset(-10);
        }];
    }
    return _title;
}

- (UILabel*)subtitle
{
    if (!_subtitle)
    {
        _subtitle = [UILabel new];
        _subtitle.font = FONT_SF_DISPLAY_REGULAR(12);
        _subtitle.textColor = [UIColor whiteColor];
        [self addSubview:_subtitle];
        [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.leftIcon.mas_right).offset(10);
            make.top.equalTo(self.mas_centerY).offset(3);
            make.right.equalTo(self.rightIcon.mas_left).offset(-10);
        }];
    }
    return _subtitle;
}

- (UIImageView*)rightIcon
{
    if (!_rightIcon)
    {
        _rightIcon = [UIImageView new];
        [self addSubview:_rightIcon];
        [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.right.equalTo(self).offset(-20);
            make.centerY.equalTo(self);
        }];
    }
    return _rightIcon;
}

@end
