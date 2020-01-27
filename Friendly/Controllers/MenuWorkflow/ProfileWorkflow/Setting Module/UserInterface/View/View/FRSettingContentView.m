//
//  FRSettingContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSettingContentView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRSettingContentView ()

@property (nonatomic, strong) UIView* navBar;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRSettingContentView

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.titleLabel.text = FRLocalizedString(@"Settings", nil);
        [self separator];
    }
    return self;
}

#pragma mark - Lazy Load

- (UIView*)navBar
{
    if (!_navBar)
    {
        _navBar = [UIView new];
        _navBar.backgroundColor = [UIColor whiteColor];
        [self addSubview:_navBar];
        
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@(kNavBarHeight));
        }];
    }
    return _navBar;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#3E4657"];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(20);
        [self.navBar addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.navBar);
            make.centerY.equalTo(self.backButton);
        }];
    }
    return _titleLabel;
}
- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [_backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[[UIColor bs_colorWithHexString:@"929AB0"] colorWithAlphaComponent:0.8]] forState:UIControlStateHighlighted];
        
        [self.navBar addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.equalTo(self.navBar);
            make.width.height.equalTo(@44);
        }];
    }
    return _backButton;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        _tableView.bounces = NO;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
    }
    return _tableView;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:@"E4E6EA"]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.navBar);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}
@end
