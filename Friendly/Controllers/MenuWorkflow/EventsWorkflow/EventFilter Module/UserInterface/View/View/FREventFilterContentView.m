//
//  FREventFilterContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 21.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterContentView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FREventFilterContentView ()

@property (nonatomic, strong) UIView* navView;
@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation FREventFilterContentView


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self titleLabel];
    }
    return self;
}


#pragma mark - Lazy Load

- (UIView*)navView
{
    if (!_navView)
    {
        _navView = [UIView new];
        _navView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_navView];
        
        [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navView;
}

- (UIButton*)closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        UIImage* closeImage = [UIImageHelper image:[FRStyleKit imageOfNavCloseCanvas] color:[UIColor bs_colorWithHexString:@"929AAF"]];
        [_closeButton setImage:closeImage forState:UIControlStateNormal];
        [self.navView addSubview:_closeButton];
        
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@44);
            make.left.bottom.equalTo(self.navView);
        }];
    }
    return _closeButton;
}

- (UIButton*)doneButton
{
    if (!_doneButton)
    {
        _doneButton = [UIButton new];
        _doneButton.titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(18);
        [_doneButton setTitle:FRLocalizedString(@"Done", nil) forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor bs_colorWithHexString:@"929AAF"] forState:UIControlStateNormal];
        [_doneButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.navView addSubview:_doneButton];
        
        [_doneButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.bottom.equalTo(self.navView);
            make.right.equalTo(self.navView).offset(-15);
        }];
    }
    return _doneButton;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = FRLocalizedString(@"Filter", nil);
        [_titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(18)];
        _titleLabel.textColor = [UIColor blackColor];
        [self.navView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navView);
            make.height.equalTo(@44);
            make.bottom.equalTo(self.navView);
        }];
    }
    return _titleLabel;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.navView.mas_bottom).offset(10);
        }];
    }
    return _tableView;
}
@end
