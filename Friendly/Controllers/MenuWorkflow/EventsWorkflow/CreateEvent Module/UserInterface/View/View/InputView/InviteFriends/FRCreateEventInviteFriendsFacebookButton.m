//
//  FRCreateEventInviteFriendsFacebookButton.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 22.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteFriendsFacebookButton.h"
#import "FRStyleKit.h"

@interface FRCreateEventInviteFriendsFacebookButton()

@property (strong, nonatomic) UIImageView* fbIcon;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UILabel* inviteLabel;

@end

@implementation FRCreateEventInviteFriendsFacebookButton

-(instancetype) init
{
    self = [super init];
    if (self) {
        [self fbIcon];
//        [self separator];
        self.separator.hidden = YES;
        [self inviteLabel];
        self.layer.cornerRadius = 4;
        self.backgroundColor = [UIColor bs_colorWithHexString:@"2374CA"];
    }
    return self;
}


#pragma mark - LazyLoad

-(UIImageView*) fbIcon
{
    if (!_fbIcon)
    {
        _fbIcon = [UIImageView new];
//        _fbIcon.backgroundColor = [UIColor whiteColor];
        [_fbIcon setImage:[FRStyleKit imageOfFbBlueIcon]];
        [self addSubview:_fbIcon];
        [_fbIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(10);
            make.height.equalTo(@15);
            make.width.equalTo(@15);
        }];
        
    }
    return _fbIcon;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fbIcon.mas_right).offset(4);
            make.height.equalTo(self.fbIcon);
            make.width.equalTo(@0.5);
            make.top.bottom.equalTo(self.fbIcon);
        }];
    }
    return _separator;
}

-(UILabel*) inviteLabel
{
    if (!_inviteLabel)
    {
        _inviteLabel = [UILabel new];
        [_inviteLabel setText:@"Invite"];
        [_inviteLabel setTextColor:[UIColor whiteColor]];
        _inviteLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(15);
        [self addSubview:_inviteLabel];
        [_inviteLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.fbIcon.mas_right).offset(4);
            make.centerY.equalTo(self);
        }];
    }
    return _inviteLabel;
}

@end
