//
//  FRFriendsEventsNavBar.m
//  Friendly
//
//  Created by Dmitry on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsNavBar.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRFriendsEventsNavBar ()

@property (nonatomic, strong) UIView* backView;


@end

@implementation FRFriendsEventsNavBar


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIView* sep = [UIView new];
        sep.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.backView addSubview:sep];
        [sep mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.backView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}
- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    return _backView;
}

- (UIButton*)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"ADB6CE"]] forState:UIControlStateNormal];
        [self.backView addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.left.equalTo(self.backView).offset(10);
            make.bottom.equalTo(self.backView);
        }];
    }
    return _leftButton;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#3E4657"];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(18);
        [self.backView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backView);
        }];
    }
    return _titleLabel;
}
@end
