//
//  DownView.m
//  Project
//
//  Created by Jane Doe on 2/29/16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import "FREventPreviewDownView.h"
#import "FREventPreviewDateView.h"
#import "FREventPreviewAttendingPeopleView.h"

@interface FREventPreviewDownView()

@property (strong, nonatomic) UIButton* joinButton;
@property (strong, nonatomic) FREventPreviewDateView* dateView;
@property (strong, nonatomic) UIView* separator;

@end

@implementation FREventPreviewDownView

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self joinButton];
        [self dateView];
        [self attendingView];
        [self separator];
    }
    return self;
}


#pragma mark - LazyLoad

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(@2);
        }];
    }
    return _separator;
}

-(FREventPreviewDateView*) dateView
{
    if (!_dateView)
    {
        _dateView = [FREventPreviewDateView new];
        [self addSubview:_dateView];
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(5);
            make.width.height.equalTo(@50);
        }];
    }
    return _dateView;
}

-(FREventPreviewAttendingPeopleView*) attendingView
{
    if (!_attendingView)
    {
        _attendingView = [FREventPreviewAttendingPeopleView new];
        [self addSubview:_attendingView];
        [_attendingView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateView.mas_right);
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.joinButton.mas_left);
        }];
    }
    return _attendingView;
}

-(UIButton*) joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
        [_joinButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = [UIFont systemFontOfSize:14];
        _joinButton.layer.cornerRadius = 4;
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [self addSubview:_joinButton];
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.right.equalTo(self).offset(-10);
            make.height.equalTo(@35);
            make.width.equalTo(@90);
        }];
    }
    return _joinButton;
}

@end
