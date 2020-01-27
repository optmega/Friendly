//
//  FRHomeNavigationBarView.m
//  Friendly
//
//  Created by Dmitry on 03.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRHomeNavigationBarView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRHomeNavigationBarView ()

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, strong) UIView* backView;

@end

@implementation FRHomeNavigationBarView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.backView.alpha = 0;
        [self title];
        
        UIView* separator = [UIView new];
        separator.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        [self.contentView addSubview:separator];
        [separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return self;
}

- (void)setColorAlpha:(CGFloat)alpha
{
    self.backView.alpha = alpha;
}

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor bs_colorWithHexString:@"6851FA"];
        [self addSubview:_backView];
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _backView;
}

- (UIView*)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.height.equalTo(@44);
        }];
    }
    return _contentView;
}

- (UIButton*)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [UIButton new];
        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfNavFilterCanvas] color:[UIColor bs_colorWithHexString:@"#ADB6CE"]];
        [_leftButton setImage:image forState:UIControlStateNormal];
        [self.contentView addSubview:_leftButton];
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(10);
        }];
    }
    return _leftButton;
}

- (UIButton*)rightButton
{
    if (!_rightButton)
    {
        _rightButton = [UIButton new];
        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfPage1Canvas4] color:[UIColor bs_colorWithHexString:@"ADB6CE"]];
        [_rightButton setImage:image forState:UIControlStateNormal];
        [self.contentView addSubview:_rightButton];
        [_rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.bottom.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-10);
        }];
    }
    return _rightButton;
}

//- (UILabel*)titleLabel
//{
//    if (!_titleLabel)
//    {
//        _titleLabel = [UILabel new];
//        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(20);
//        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"3D4556"];
//        [self.contentView addSubview:_titleLabel];
//        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.bottom.equalTo(self.contentView);
//            make.left.equalTo(self.leftButton.mas_right);
//            make.right.equalTo(self.rightButton.mas_left);
//        }];
//    }
//    return _titleLabel;
//}

- (UIImageView*)title
{
    if (!_title)
    {
        _title = [UIImageView new];
        _title.contentMode = UIViewContentModeScaleAspectFit;
        _title.image = [UIImage imageNamed:@"Header-logo"];
        //        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
//                _titleLabel.font = FONT_SF_DISPLAY_BOLD(16);
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.leftButton.mas_right);
//            make.right.equalTo(self.rightButton.mas_left);
            make.center.equalTo(self.contentView);
//            make.width.equalTo(@85);
            make.height.equalTo(@30);
        }];
    }
    return _title;
}

@end
