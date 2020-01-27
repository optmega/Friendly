//
//  WhiteHeaderVC.m
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "WhiteHeaderVC.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@implementation WhiteHeaderVC

-(void) viewDidLoad
{
    [super viewDidLoad];
    [self toolbar];
    [self closeButton];
    [self titleLabel];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

-(void) backHome:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    CATransition* transition = [CATransition animation];
    transition.duration = 0.4;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionReveal; //kCATransitionMoveIn; //, kCATransitionPush, kCATransitionReveal, kCATransitionFade
    transition.subtype = kCATransitionFromBottom; //kCATransitionFromLeft, kCATransitionFromRight, kCATransitionFromTop, kCATransitionFromBottom
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController popToRootViewControllerAnimated:NO];
}


#pragma mark - LazyLoad

-(UIToolbar*) toolbar
{
    if (!_toolbar)
    {
        _toolbar = [UIToolbar new];
        [_toolbar setBackgroundColor:[UIColor whiteColor]];
        _toolbar.translucent = NO;
        _toolbar.barTintColor = [UIColor whiteColor];
        _toolbar.tintColor = [UIColor whiteColor];
        _toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        [self.view addSubview:_toolbar];
        [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@65);
        }];
    }
    return _toolbar;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [_titleLabel setFont:FONT_PROXIMA_NOVA_SEMIBOLD(18)];
        [self.toolbar addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.toolbar);
            make.bottom.equalTo(self.toolbar).offset(-15);
        }];
    }
    return _titleLabel;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        
        [_closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavCloseCanvas] color:[UIColor bs_colorWithHexString:@"929AAF"]] forState:UIControlStateNormal];

        [_closeButton setBackgroundColor:[UIColor whiteColor]];
        [_closeButton addTarget:self action:@selector(backHome:) forControlEvents:UIControlEventTouchUpInside];
        [self.toolbar addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolbar).offset(15);
            make.bottom.equalTo(self.toolbar).offset(-15);
            make.height.width.equalTo(@20);
        }];
    }
    return _closeButton;
}


@end
