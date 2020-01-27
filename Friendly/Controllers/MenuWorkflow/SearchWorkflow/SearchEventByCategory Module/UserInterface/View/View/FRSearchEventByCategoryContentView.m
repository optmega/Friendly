//
//  FRSearchEventByCategoryContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryContentView.h"

@implementation FRSearchEventByCategoryContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (FRSearchNavBarView*)navBar
{
    if (!_navBar)
    {
        _navBar = [FRSearchNavBarView new];
        [self addSubview:_navBar];
        [_navBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.height.equalTo(@(64));
        }];
    }
    return _navBar;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        [self addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            make.top.equalTo(self.navBar.mas_bottom);
        }];
    }
    return _tableView;
}


@end
