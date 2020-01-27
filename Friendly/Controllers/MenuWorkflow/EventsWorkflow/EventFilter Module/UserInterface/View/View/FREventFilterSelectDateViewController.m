//
//  FREventFilterSelectDateViewController.m
//  Friendly
//
//  Created by User on 13.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterSelectDateViewController.h"

@interface FREventFilterSelectDateViewController ()

@property (strong, nonatomic) UIButton* thisWeekButton;
@property (strong, nonatomic) UIButton* thisWeekendButton;
@property (strong, nonatomic) UIButton* anyTimeButton;

@end

@implementation FREventFilterSelectDateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self thisWeekButton];
    [self thisWeekendButton];
    [self anyTimeButton];
}

-(void)selectedDate:(UIButton*)sender
{
    if ([sender.titleLabel.text  isEqual: @"This weekend"])
    {
        [self.delegate selectedDate:FRDateFilterThisWeekend andText:sender.titleLabel.text];
    }
    if ([sender.titleLabel.text  isEqual: @"This week"])
    {
        [self.delegate selectedDate:FRDateFilterThisWeek andText:sender.titleLabel.text];
    }
    if ([sender.titleLabel.text  isEqual: @"Anytime"])
    {
        [self.delegate selectedDate:FRDateFilterAnyTime andText:sender.titleLabel.text];
    }
    [self closeVC];
}

-(UIButton*)thisWeekendButton
{
    if (!_thisWeekendButton)
    {
        _thisWeekendButton = [UIButton new];
        [_thisWeekendButton setTitle:@"This weekend" forState:UIControlStateNormal];
        [_thisWeekendButton setTitleColor:[UIColor bs_colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        _thisWeekendButton.layer.borderWidth = 0.5;
        _thisWeekendButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        [_thisWeekendButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_thisWeekendButton];
        [_thisWeekendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.heightFooter/3));
            make.left.right.top.equalTo(self.footerView);
        }];
    }
    return _thisWeekendButton;
}

-(UIButton*)thisWeekButton
{
    if (!_thisWeekButton)
    {
        _thisWeekButton = [UIButton new];
        [_thisWeekButton setTitle:@"This week" forState:UIControlStateNormal];
        [_thisWeekButton setTitleColor:[UIColor bs_colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        _thisWeekButton.layer.borderWidth = 0.5;
        _thisWeekButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        [_thisWeekButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_thisWeekButton];
        [_thisWeekButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.heightFooter/3));
            make.left.right.equalTo(self.footerView);
            make.top.equalTo(self.thisWeekendButton.mas_bottom);
        }];
    }
    return _thisWeekButton;
}

-(UIButton*)anyTimeButton
{
    if (!_anyTimeButton)
    {
        _anyTimeButton = [UIButton new];
        [_anyTimeButton setTitle:@"Anytime" forState:UIControlStateNormal];
        [_anyTimeButton setTitleColor:[UIColor bs_colorWithHexString:kTitleColor] forState:UIControlStateNormal];
        _anyTimeButton.layer.borderWidth = 0.5;
        _anyTimeButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        [_anyTimeButton addTarget:self action:@selector(selectedDate:) forControlEvents:UIControlEventTouchUpInside];
        [self.footerView addSubview:_anyTimeButton];
        [_anyTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.heightFooter/3));
            make.left.right.equalTo(self.footerView);
            make.top.equalTo(self.thisWeekButton.mas_bottom);
        }];
    }
    return _anyTimeButton;
}

@end
