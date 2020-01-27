//
//  FRAddInterestsContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 02.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsContentView.h"
#import "FRHeaderQuestionairView.h"
#import "FRFooterQuestionairView.h"
#import "FRStyleKit.h"

@interface FRAddInterestsContentView () <UISearchBarDelegate>

@property (nonatomic, strong) UIView* navBar;
@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIImageView* headerCornerImage;

@end

@implementation FRAddInterestsContentView

- (void)dealoc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {

        self.backgroundColor = [UIColor whiteColor];
        [self headerCornerImage];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tableTapped) name:@"hideKeyboardFromSearchBar" object:nil];
    }
    return self;
}

- (void)tableTapped
{
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-50);
    }];
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped)];
        [_tableView addGestureRecognizer:tap];
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.right.equalTo(self);
            make.bottom.equalTo(self).offset(-50);
        }];
    }
    return _tableView;
}

- (FRFooterQuestionairView*)footerView
{
    if (!_footerView)
    {
        _footerView = [[FRFooterQuestionairView alloc]initWithCurrentPage:1 allPage:3 nextButtonTitle:@"Continue" hideSkip:YES];
        [self addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _footerView;
}


-(UIImageView*)headerCornerImage
{
    if (!_headerCornerImage)
    {
        _headerCornerImage = [UIImageView new];
        [_headerCornerImage setImage:[FRStyleKit imageOfGroup4Canvas2]];
        _headerCornerImage.layer.zPosition += 1;
        [self addSubview:_headerCornerImage];
//        [self.tableView bringSubviewToFront:_headerCornerImage];
        [_headerCornerImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.tableView);
            make.height.equalTo(@10);
        }];
    }
    return _headerCornerImage;
}


@end
