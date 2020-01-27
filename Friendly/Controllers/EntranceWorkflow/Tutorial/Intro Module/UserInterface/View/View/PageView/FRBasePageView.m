//
//  FRBasePageView.m
//  Friendly
//
//  Created by Sergey Borichev on 28.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBasePageView.h"

@interface FRBasePageView ()


@end

@implementation FRBasePageView


#pragma mark - Lazy Load


- (instancetype)initWithTitle:(NSString *)title subTitle:(NSString *)subTitle
{
    self = [self init];
    if (self)
    {
        [self contentView];
        self.titleLabel.attributedText = [self string:title lineSpacing:5];
        self.subtitleLabel.attributedText = [self string:subTitle lineSpacing:5];
        
    }
    return self;
}


- (NSAttributedString*)string:(NSString*)text lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    return  attributedString;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        if (IS_IPHONE_5_OR_HIGHER) {
            
            _titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(22);
        } else {
            _titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(18);
        }
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.numberOfLines = 2;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
//            CGFloat height = [UIScreen mainScreen].bounds.size.height / 9.88; //for iphone 6 == 67.5
            CGFloat height = [UIScreen mainScreen].bounds.size.height / 13; //for iphone 6 == 67.5
            make.top.equalTo(self).offset(height);
            make.height.equalTo(@100);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(17);
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _subtitleLabel.numberOfLines = 2;
        [self addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            CGFloat height = [UIScreen mainScreen].bounds.size.height / 9.01;
            CGFloat height = [UIScreen mainScreen].bounds.size.height / 8.5;
            make.bottom.equalTo(self).offset(-height);
            make.left.right.equalTo(self);
        }];
    }
    return _subtitleLabel;
}

- (UIView*)contentView
{
    if (!_contentView)
    {
        _contentView = [UIView new];
        [self addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(4);
            make.bottom.equalTo(self.mas_bottom).offset(-120);
        }];
    }
    return _contentView;
}

@end
