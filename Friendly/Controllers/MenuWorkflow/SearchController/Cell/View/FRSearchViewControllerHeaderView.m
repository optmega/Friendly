//
//  FRSearchViewControllerHeaderView.m
//  Friendly
//
//  Created by User on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerHeaderView.h"

@implementation FRSearchViewControllerHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self titleLabel];
        [self allCategoriesButton];
        self.allCategoriesButton.hidden = YES;
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLabel;

}

- (UIButton*) allCategoriesButton
{
    if (!_allCategoriesButton)
    {
        _allCategoriesButton = [UIButton new];
        [_allCategoriesButton setTitle:@"All categories" forState:UIControlStateNormal];
        [_allCategoriesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allCategoriesButton.layer.cornerRadius = 3;
//        [_allCategoriesButton addTarget:self action:@selector(backToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
        [_allCategoriesButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        _allCategoriesButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        [self.contentView addSubview:_allCategoriesButton];
        //        [self.view insertSubview:_allCategoriesButton belowSubview:self.searchToolBar];
        [_allCategoriesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView);
            make.width.equalTo(@95.5);
            make.height.equalTo(@28);
        }];
    }
    return _allCategoriesButton;
}

@end
