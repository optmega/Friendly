//
//  FREventRequestsInviteHeader.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventRequestsInviteHeader.h"

@interface FREventRequestsInviteHeader()

@property (nonatomic, strong) UIView* horizontalSeparator;
@property (nonatomic, strong) UIView* upperGreyView;
@property (nonatomic, strong) UIView* headerView;

@end

@implementation FREventRequestsInviteHeader

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self titleLabel];
        [self horizontalSeparator];
        [self upperGreyView];
        [self headerView];
    }
    return self;
}


#pragma mark - LazyLoad

-(UIView*) upperGreyView
{
    if (!_upperGreyView)
    {
        _upperGreyView = [UIView new];
        [_upperGreyView setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_upperGreyView];
        [_upperGreyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@10);
            make.top.left.right.equalTo(self.contentView);
        }];
    }
    return _upperGreyView;
}

-(UIView*) headerView
{
    if (!_headerView)
    {
        _headerView = [UIView new];
        [_headerView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.upperGreyView.mas_bottom);
            make.height.equalTo(@45);
        }];
    }
    return _headerView;
}


-(UIView*) horizontalSeparator
{
    if (!_horizontalSeparator)
    {
        _horizontalSeparator = [UIView new];
        [_horizontalSeparator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.headerView addSubview:_horizontalSeparator];
        [_horizontalSeparator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.headerView);
            make.height.equalTo(@1);
        }];
    }
    return _horizontalSeparator;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        [_titleLabel setText:@"INVITES TO EVENTS"];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [self.headerView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView).offset(15);
            make.centerY.equalTo(self.headerView);
        }];
    }
    return _titleLabel;
}

@end
