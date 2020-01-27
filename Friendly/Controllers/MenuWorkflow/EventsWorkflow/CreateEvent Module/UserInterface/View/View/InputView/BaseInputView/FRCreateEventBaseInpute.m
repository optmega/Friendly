//
//  FRCreateEventBaseInpute.m
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventBaseInpute.h"
#import "FRStyleKit.h"

@interface FRCreateEventBaseInpute()

@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) UIView* headerSeparator;
@property (nonatomic, strong) UIView* cancelButtonSeparator;

@end


@implementation FRCreateEventBaseInpute

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self.closeButton addTarget:self action:@selector(closeSelected) forControlEvents:UIControlEventTouchUpInside];
        [self headerView];
        [self separator];
        [self cancelButtonSeparator];
        [self headerSeparator];
        [self cancelButton];
        
    }
    return self;
}

- (void)closeSelected
{
    
}

#pragma mark - Lazy Load

- (UIView*)headerSeparator
{
    if (!_headerSeparator)
    {
        _headerSeparator = [UIView new];
        _headerSeparator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.headerView addSubview:_headerSeparator];
        
        [_headerSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.headerView);
            make.height.equalTo(@1);
        }];
    }
    return _headerSeparator;
}


- (UIButton*)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        UIImage *image = [FRStyleKit imageOfNavCloseCanvas];
        [_closeButton setImage:[image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
        [_closeButton.imageView setTintColor:[UIColor bs_colorWithHexString:@"#BCC0CB"]];
        [self.headerView addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.equalTo(self).offset(15);
            make.height.width.equalTo(@20);
        }];
    }
    return _closeButton;
}


- (UIView*)headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        
        [self addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@54.5);
        }];
    }
    return _headerView;
}


- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.headerView addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.right.left.equalTo(self.headerView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

- (UIView*)cancelButtonSeparator
{
    if (!_cancelButtonSeparator)
    {
        _cancelButtonSeparator = [UIView new];
        _cancelButtonSeparator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.cancelButton addSubview:_cancelButtonSeparator];
        
        [_cancelButtonSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.cancelButton);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}



- (UIButton*)cancelButton
{
    if (!_cancelButton)
    {
        _cancelButton = [UIButton new];
        _cancelButton.backgroundColor = [UIColor whiteColor];
        [_cancelButton setTitle:FRLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor bs_colorWithHexString:@"8a909d"] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font = FONT_PROXIMA_NOVA_REGULAR(18);
        [_cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self addSubview:_cancelButton];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@51);
        }];
    }
    return _cancelButton;
}

@end