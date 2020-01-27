//
//  FRProfilePolishContentVIew.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishContentVIew.h"
#import "FRStyleKit.h"
#import "FRHeaderQuestionairView.h"
#import "FRFooterQuestionairView.h"

@interface FRProfilePolishContentVIew ()

@property (strong, nonatomic) UIImageView* footerImage;

@end


@implementation FRProfilePolishContentVIew

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self footerImage];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
    }
    return self;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-50);
        }];
    }
    return _tableView;
}

- (FRFooterQuestionairView*)footerView
{
    if (!_footerView)
    {
        _footerView = [[FRFooterQuestionairView alloc]initWithCurrentPage:3 allPage:3 nextButtonTitle:@"Finish" hideSkip:YES];
        _footerView.clipsToBounds = YES;
        [self addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _footerView;
}

- (UIImageView*)footerImage
{
    if (!_footerImage)
    {
        _footerImage = [UIImageView new];
        [_footerImage setImage:[FRStyleKit imageOfGroup4CopyCanvas]];
        [self.footerView addSubview:_footerImage];
        
        [_footerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@10);
        }];
    }
    return _footerImage;
}

@end
