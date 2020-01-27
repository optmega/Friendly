//
//  FRFriendRequestsView.m
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsView.h"
#import "FRRequestNavView.h"

@interface FRFriendRequestsView ()

@end

@implementation FRFriendRequestsView

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}
#pragma mark - Lazy Load

- (FRRequestNavView*)navBar
{
    if (!_navBar)
    {
        _navBar = [FRRequestNavView new];
        _navBar.titleLabel.text = FRLocalizedString(@"Friend requests", nil);
        [self addSubview:_navBar];
        
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.contentInset = UIEdgeInsetsMake(17, 0, 0, 0);
        _tableView.separatorColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
    }
    return _tableView;
}

@end
