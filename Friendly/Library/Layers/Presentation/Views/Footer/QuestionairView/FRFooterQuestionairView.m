//
//  FRFooterQuestionairView.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFooterQuestionairView.h"

@interface FRFooterQuestionairView ()

@property (nonatomic, strong) UILabel* countLabel;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRFooterQuestionairView

- (instancetype)initWithCurrentPage:(NSInteger)page allPage:(NSInteger)allPage nextButtonTitle:(NSString*)title hideSkip:(BOOL)hideSkip
{
    self = [self init];
    if (self){
        self.countLabel.text = [NSString stringWithFormat:@"Step %ld of %ld", (long)page, (long)allPage];
        self.skipButton.hidden = hideSkip;
        [self.continueButton setTitle:title forState:UIControlStateNormal];
        [self separator];
    }
    return self;
}


#pragma mark - Lazy Load

- (UILabel*)countLabel
{
    if (!_countLabel)
    {
        _countLabel = [UILabel new];
        _countLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _countLabel.font = FONT_MAIN_FONT(13);
        [self addSubview:_countLabel];
        
        [_countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(20);
        }];
    }
    return _countLabel;
}

- (UIButton*)continueButton
{
    if (!_continueButton)
    {
        _continueButton = [UIButton new];
        _continueButton.enabled = false;
        _continueButton.layer.cornerRadius = 5;
        _continueButton.backgroundColor = [UIColor bs_colorWithHexString:@"00B3FC"];
        _continueButton.titleLabel.font = FONT_MAIN_FONT(14);
        [_continueButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_continueButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        [_continueButton setBackgroundImage:[UIImage imageNamed:@"disabled"] forState:UIControlStateDisabled];
        _continueButton.clipsToBounds = YES;
        [self addSubview:_continueButton];
        
        [_continueButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.height.equalTo(@32);
            make.width.equalTo(@85);
            make.right.equalTo(self).offset(-20);
        }];
    }
    return _continueButton;
}

- (UIButton*)skipButton
{
    if (!_skipButton)
    {
        _skipButton = [UIButton new];
        _skipButton.titleLabel.font = FONT_MAIN_FONT(14);
        [_skipButton setTitle:@"Skip" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor bs_colorWithHexString:@"9ca0ab"] forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self addSubview:_skipButton];
        
        [_skipButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self.continueButton.mas_left).offset(-10);
        }];
    }
    return _skipButton;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        [self addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}
@end
