//
//  FRFriendRequestHeaderView.m
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestHeaderView.h"

@interface FRFriendRequestHeaderView ()

@property (nonatomic, strong) UIView* backView;
@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation FRFriendRequestHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        
    }
    return self;
}

- (void)updateWithModel:(FRFriendRequestHeaderViewModel*)model
{
    self.titleLabel.text = model.title;
}


#pragma mark - Lazy Load

- (UIView*)backView
{
    if (!_backView)
    {
        _backView = [UIView new];
        _backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_backView];
        
        [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.height.equalTo(@50);
            make.bottom.equalTo(self.contentView).offset(-1);
        }];
    }
    return _backView;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.backView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backView).offset(20);
            make.centerY.equalTo(self.backView);
        }];
    }
    return _titleLabel;
}

@end
