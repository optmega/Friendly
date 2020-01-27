//
//  FRSearchDiscoverPeopleContentIView.m
//  Friendly
//
//  Created by Sergey Borichev on 19.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleContentView.h"

@implementation FRSearchDiscoverPeopleContentView


- (FRSearchNavBarView*)navBar
{
    if (!_navBar)
    {
        _navBar = [FRSearchNavBarView new];
        [self addSubview:_navBar];
        
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.height.equalTo(@64);
        }];
    }
    return _navBar;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        _tableView.separatorColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.navBar.mas_bottom);
            make.left.right.bottom.equalTo(self);
        }];
    }
    return _tableView;
}


@end
