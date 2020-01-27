//
//  FRMyProfileStatusInputView.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileStatusInputView.h"

@interface FRMyProfileStatusInputView ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* freeButton;
@property (nonatomic, strong) UIButton* openToHostButton;
@property (nonatomic, strong) UIButton* availableButton;
@property (nonatomic, strong) UIButton* busyButton;

@end

static CGFloat const kLeftOffset = 15;
static CGFloat const kHeight = 45;
static CGFloat const kTopOffset = 8;



@implementation FRMyProfileStatusInputView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.cancelButton.hidden = YES;
        [self.freeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.openToHostButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.availableButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.busyButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self titleLabel];
        
        [self.closeButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonAction:(UIButton*)sender
{
             UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:
                                       @"Error" message: @""  delegate:self
                                                      cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
             [alertView show];

    [self.delegate selectedStatus:sender.titleLabel.text];
}

- (void)closeAction
{
    [self.delegate close];
}

#pragma mark - Lazy Load



- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = FRLocalizedString(@"Availability status", nil);
        _titleLabel.font = FONT_SF_TEXT_REGULAR(18);
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.headerView);
        }];
    }
    return _titleLabel;
}
- (UIButton*)freeButton
{
    if (!_freeButton)
    {
        _freeButton = [UIButton new];
        [_freeButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        [_freeButton setTitle:FRLocalizedString(@"Free this weekend", nil) forState:UIControlStateNormal];
        _freeButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        _freeButton.layer.cornerRadius = 5;
        _freeButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _freeButton.layer.borderWidth = 1;
        [self addSubview:_freeButton];
        
        [_freeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.headerView.mas_bottom).offset(20);
        }];
    }
    return _freeButton;
}

- (UIButton*)openToHostButton
{
    if (!_openToHostButton)
    {
        _openToHostButton = [UIButton new];
        _openToHostButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        [_openToHostButton setTitle:FRLocalizedString(@"Open to co-host event", nil) forState:UIControlStateNormal];
        [_openToHostButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        _openToHostButton.layer.cornerRadius = 5;
        _openToHostButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _openToHostButton.layer.borderWidth = 1;
        [self addSubview:_openToHostButton];
        
        [_openToHostButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.freeButton.mas_bottom).offset(kTopOffset);
        }];
    }
    return _openToHostButton;
}

- (UIButton*)availableButton
{
    if (!_availableButton)
    {
        _availableButton = [UIButton new];
        _availableButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(16);
        [_availableButton setTitle:FRLocalizedString(@"Available for a meet", nil) forState:UIControlStateNormal];
        [_availableButton setTitleColor:[UIColor bs_colorWithHexString:@"8B97AE"] forState:UIControlStateNormal];
        _availableButton.layer.cornerRadius = 5;
        _availableButton.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBE1"].CGColor;
        _availableButton.layer.borderWidth = 1;
        [self addSubview:_availableButton];
        
        [_availableButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.openToHostButton.mas_bottom).offset(kTopOffset);
        }];
    }
    return _availableButton;
}

- (UIButton*)busyButton
{
    if (!_busyButton)
    {
        _busyButton = [UIButton new];
        _busyButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16);
        [_busyButton setTitle:FRLocalizedString(@"Busy", nil) forState:UIControlStateNormal];
        [_busyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _busyButton.backgroundColor = [UIColor bs_colorWithHexString:@"FF6868"];
        _busyButton.layer.cornerRadius = 5;
        _busyButton.layer.borderColor = [UIColor bs_colorWithHexString:@"FF6868"].CGColor;
        _busyButton.layer.borderWidth = 1;
        [self addSubview:_busyButton];
        
        [_busyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(kLeftOffset);
            make.right.equalTo(self).offset(-kLeftOffset);
            make.height.equalTo(@(kHeight));
            make.top.equalTo(self.availableButton.mas_bottom).offset(kTopOffset);
        }];
    }
    return _busyButton;
}
@end
