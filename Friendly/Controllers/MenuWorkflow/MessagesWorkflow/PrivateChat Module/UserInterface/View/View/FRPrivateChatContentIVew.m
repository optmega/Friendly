//
//  FRPrivateChatContentIVew.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatContentIVew.h"
#import "FRPrivateChatHeaderView.h"
#import "FRPrivateChatInputView.h"

@interface FRPrivateChatContentIVew ()

@property (nonatomic, strong) FRPrivateChatInputView* inputChatView;
@property (nonatomic, strong) MASConstraint* heightInputConstraint;
@end

@implementation FRPrivateChatContentIVew

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self inputChatView];
    }
    return self;
}

#pragma mark - LazyLoad

- (FRPrivateChatHeaderView*)headerView
{
    if (!_headerView)
    {
        _headerView = [FRPrivateChatHeaderView new];
        [self addSubview:_headerView];
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _headerView;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self.inputChatView.mas_top);
        }];
    }
    return _tableView;
}


- (FRPrivateChatInputView*)inputChatView
{
    if (!_inputChatView)
    {
        _inputChatView = [FRPrivateChatInputView new];
        [self addSubview:_inputChatView];
        [_inputChatView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            self.heightInputConstraint = make.height.equalTo(@(45));
        }];
    }
    return _inputChatView;
}

- (FRGroupChatNavigationView*)navBar
{
    if (!_navBar)
    {
        _navBar = [[[UINib nibWithNibName:@"FRGroupChatNavigationView" bundle:nil] instantiateWithOwner:self options:nil] objectAtIndex:0];
        
        [self addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}


@end
