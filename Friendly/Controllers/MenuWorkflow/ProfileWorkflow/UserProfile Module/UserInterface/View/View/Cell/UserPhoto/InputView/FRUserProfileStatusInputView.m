//
//  FRMyProfileStatusInputView.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileStatusInputView.h"

@interface FRUserProfileStatusInputView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* reportUserButton;
@property (nonatomic, strong) UIButton* blockUserButton;
@property (nonatomic, strong) UIButton* cancelButton;

@end

static CGFloat const kLeftOffset = 15;
static CGFloat const kHeight = 45;
static CGFloat const kTopOffset = 5;



@implementation FRUserProfileStatusInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
       
        [self.reportUserButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.blockUserButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.cancelButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.removeUserButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [self titleLabel];
        
    }
    return self;
}

-(void)updateButtons
{
    self.removeUserButton.hidden = YES;
    [self.reportUserButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self).offset(20);
    }];
}

- (void)buttonAction:(UIButton*)sender
{
    [self.delegate selectedStatus:sender.titleLabel.text];
//    [self.delegate close];
}

- (void)closeAction
{
//    [self.delegate close];
}

#pragma mark - Lazy Load


- (UIButton*)reportUserButton
{
    if (!_reportUserButton)
    {
        _reportUserButton = [UIButton new];
        [_reportUserButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        [_reportUserButton setTitle:FRLocalizedString(@"Report user", nil) forState:UIControlStateNormal];
        _reportUserButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        _reportUserButton.layer.cornerRadius = 5;
        _reportUserButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _reportUserButton.layer.borderWidth = 1;
        [self addSubview:_reportUserButton];
        
        [_reportUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.removeUserButton.mas_bottom).offset(kTopOffset);
        }];
    }
    return _reportUserButton;
}

- (UIButton*)removeUserButton
{
    if (!_removeUserButton)
    {
        _removeUserButton = [UIButton new];
        [_removeUserButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        [_removeUserButton setTitle:FRLocalizedString(@"Remove user", nil) forState:UIControlStateNormal];
        _removeUserButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        _removeUserButton.layer.cornerRadius = 5;
        _removeUserButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _removeUserButton.layer.borderWidth = 1;
        [self addSubview:_removeUserButton];
        
        [_removeUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self).offset(20);
        }];
    }
    return _removeUserButton;
}

- (UIButton*)blockUserButton
{
    if (!_blockUserButton)
    {
        _blockUserButton = [UIButton new];
        _blockUserButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        [_blockUserButton setTitle:FRLocalizedString(@"Block user", nil) forState:UIControlStateNormal];
        [_blockUserButton setTitleColor:[UIColor bs_colorWithHexString:kAlertsColor] forState:UIControlStateNormal];
        _blockUserButton.layer.cornerRadius = 5;
        _blockUserButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _blockUserButton.layer.borderWidth = 1;
        [self addSubview:_blockUserButton];
        
        [_blockUserButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.reportUserButton.mas_bottom).offset(kTopOffset);
        }];
    }
    return _blockUserButton;
}

- (UIButton*)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton new];
        _cancelButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        [_cancelButton setTitle:FRLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        _cancelButton.layer.cornerRadius = 5;
        _cancelButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _cancelButton.layer.borderWidth = 1;
        [self addSubview:_cancelButton];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _cancelButton;
}


@end
