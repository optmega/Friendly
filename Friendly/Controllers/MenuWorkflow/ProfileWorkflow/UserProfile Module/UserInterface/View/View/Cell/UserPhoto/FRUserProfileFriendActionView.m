//
//  FRUserProfileFriendActionView.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileFriendActionView.h"

@interface FRUserProfileFriendActionView ()

@property (nonatomic, strong) UIButton* pendingButton;
@property (nonatomic, strong) UIButton* addFriendButton;
@property (nonatomic, strong) UIButton* inviteToEventButton;
@property (nonatomic, strong) UIButton* friendsButton;

@end

@implementation FRUserProfileFriendActionView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self _hideAllView];
        
        @weakify(self);
        [[self.addFriendButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate addFriendSelected];
            [self setMode:FRFriendActionModePending];
//            [self _hideAllView];
//            self.pendingButton.hidden = NO;
        }];
        
        [[self.inviteToEventButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate inviteToEventSelected];
        }];
        
        [[self.friendsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate friendsSelected];
        }];
        
        [[self.pendingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.delegate pendingSelected];
        }];
    }
    return self;
}

- (void)setMode:(FRFriendActionMode)mode
{
    [self _hideAllView];
    
    switch (mode) {
        case FRFriendActionModePending:
        {
            self.pendingButton.hidden = NO;
        }  break;
        case FRFriendActionModeFriend:
        {
            self.inviteToEventButton.hidden = NO;
            self.friendsButton.hidden = NO;
        }  break;
        case FRFriendActionModeAddFriend:
        {
            self.addFriendButton.hidden = NO;

        } break;
    }
}

- (void)_hideAllView
{
    self.pendingButton.hidden = YES;
    self.addFriendButton.hidden = YES;
    self.inviteToEventButton.hidden = YES;
    self.friendsButton.hidden = YES;
}


#pragma mark - Lazy Load

- (UIButton*)pendingButton
{
    if (!_pendingButton)
    {
        _pendingButton = [UIButton new];
        [_pendingButton setTitle:FRLocalizedString(@"Pending request", nil) forState:UIControlStateNormal];
        _pendingButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _pendingButton.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [_pendingButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_pendingButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _pendingButton.layer.cornerRadius = 5;
        _pendingButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        [self addSubview:_pendingButton];
        
        [_pendingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(@150);
        }];
    }
    return _pendingButton;
}

- (UIButton*)addFriendButton
{
    if (!_addFriendButton)
    {
        _addFriendButton = [UIButton new];
        [_addFriendButton setTitle:FRLocalizedString(@"Add as friend", nil) forState:UIControlStateNormal];
        _addFriendButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _addFriendButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_addFriendButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_addFriendButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _addFriendButton.layer.cornerRadius = 5;
        _addFriendButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        
        [self addSubview:_addFriendButton];
        
        [_addFriendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.centerX.equalTo(self);
            make.width.equalTo(@140);
        }];
    }
    return _addFriendButton;
}

- (UIButton*)inviteToEventButton
{
    if (!_inviteToEventButton)
    {
        _inviteToEventButton = [UIButton new];
       
        
        [_inviteToEventButton setTitle:FRLocalizedString(@"Invite to event", nil) forState:UIControlStateNormal];
        _inviteToEventButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _inviteToEventButton.backgroundColor = [UIColor whiteColor];
        [_inviteToEventButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_inviteToEventButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _inviteToEventButton.layer.cornerRadius = 3;
        _inviteToEventButton.layer.borderColor = [UIColor bs_colorWithHexString:kFieldTextColor].CGColor;
        _inviteToEventButton.layer.borderWidth = 0.5;
        _inviteToEventButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);

        
        [self addSubview:_inviteToEventButton];
        
        [_inviteToEventButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.right.equalTo(self.mas_centerX).offset(5);
            make.width.equalTo(@110);
        }];
    }
    return _inviteToEventButton;
}

- (UIButton*)friendsButton
{
    if (!_friendsButton)
    {
        _friendsButton = [UIButton new];
        
        [_friendsButton setTitle:FRLocalizedString(@"Friends", nil) forState:UIControlStateNormal];
        _friendsButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 5);
        _friendsButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        [_friendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_friendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _friendsButton.layer.cornerRadius = 3;
        _friendsButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        
        [self addSubview:_friendsButton];
        
        [_friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.left.equalTo(self.inviteToEventButton.mas_right).offset(7);
            make.width.equalTo(@90);
        }];
    }
    return _friendsButton;
}



@end
