//
//  FROfflineNotificationView.m
//  Friendly
//
//  Created by Jane Doe on 4/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FROfflineNotificationView.h"
#import "FRStyleKit.h"

@interface FROfflineNotificationView()

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* closeButton;

@end

@implementation FROfflineNotificationView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [[UIColor bs_colorWithHexString:@"1C163C"] colorWithAlphaComponent:0.95];
        [self titleLabel];
        [self closeButton];
    }
    return self;
}


#pragma mark - LazyLoad

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"Your connection appears to be offline"];
        [_titleLabel setTextColor:[UIColor whiteColor]];
        [_titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(14)];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.centerX.equalTo(self);
        }];
    }
    return _titleLabel;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        [_closeButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@20);
            make.right.equalTo(self).offset(-10);
            make.centerY.equalTo(self);
        }];
    }
    return _closeButton;
}

@end
