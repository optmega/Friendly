//
//  FRRequestNavView.m
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRequestNavView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRRequestNavView ()

@property (nonatomic, strong) UIView* separator;

@end


@implementation FRRequestNavView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self separator];
        self.backgroundColor = [UIColor whiteColor];
        
    }
    return self;
}

#pragma mark - Lazy Load

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

- (UIButton*)leftButton
{
    if (!_leftButton)
    {
        _leftButton = [UIButton new];
        [_leftButton setImage:[UIImageHelper image:[FRStyleKit imageOfActionBarLeaveEventBlueCanvas] color:[UIColor bs_colorWithHexString:@"#939BAF"]] forState:UIControlStateNormal];
        [self addSubview:_leftButton];
        
        [_leftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.bottom.equalTo(self);
            make.height.width.equalTo(@44);
        }];
    }
    return _leftButton;
}

- (UIButton*)rieghtButton
{
    if (!_rieghtButton)
    {
        _rieghtButton = [UIButton new];
        
        
        
        [_rieghtButton setImage:[UIImageHelper image:[FRStyleKit imageOfActionBarAddUser] color:[UIColor bs_colorWithHexString:@"#939BAF"]] forState:UIControlStateNormal];
        _rieghtButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -5, -5, 0);
        [self addSubview:_rieghtButton];
        
        [_rieghtButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.width.equalTo(@44);
        }];
    }
    return _rieghtButton;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setFont:FONT_PROXIMA_NOVA_MEDIUM(18)];
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _titleLabel;
}

@end
