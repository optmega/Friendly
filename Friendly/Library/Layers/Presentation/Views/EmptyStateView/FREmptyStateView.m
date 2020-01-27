//
//  FREmptyStateView.m
//  Friendly
//
//  Created by User on 23.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREmptyStateView.h"

@implementation FREmptyStateView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self titleLabel];
        [self subtitleLabel];
    }
    return self;
}


#pragma mark - LazyLoad

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [_titleLabel setFont:FONT_PROXIMA_NOVA_SEMIBOLD(18)];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self).offset(10);
        }];
        
    }
    return _titleLabel;
}

-(UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        [_subtitleLabel setTextColor:[UIColor bs_colorWithHexString:kTextSubtitleColor]];
        _subtitleLabel.numberOfLines = 2;
        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
        [_subtitleLabel setFont:FONT_PROXIMA_NOVA_REGULAR(16)];
        [self addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(7);
        }];
    }
    return _subtitleLabel;
}

@end
