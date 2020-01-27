//
//  FRRecommendedUsersContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersContentView.h"
#import "FRStyleKit.h"
#import "FRHeaderQuestionairView.h"
#import "FRFooterQuestionairView.h"

@interface FRRecommendedUsersContentView ()

@property (nonatomic, strong) UIView* navBar;

@end

@implementation FRRecommendedUsersContentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
    }
    return self;
}

- (UIImage *)image:(UIImage*)image
{
    UIImage *newImage = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(image.size, NO, newImage.scale);
    [[[UIColor whiteColor] colorWithAlphaComponent:0.8] set];
    [newImage drawInRect:CGRectMake(0, 0, image.size.width, newImage.size.height)];

    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
    
}

#pragma mark - Lazy Load

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        [_tableView setSeparatorColor:[UIColor whiteColor]];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.bounces = NO;
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
        _footerView = [[FRFooterQuestionairView alloc]initWithCurrentPage:2 allPage:3 nextButtonTitle:@"Continue" hideSkip:NO];
        [self addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@50);
        }];
    }
    return _footerView;
}

@end
