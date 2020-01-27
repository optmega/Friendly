//
//  FRCreateEventLocationSelectSearchNearbyButton.m
//  Friendly
//
//  Created by Jane Doe on 3/30/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventLocationSelectSearchNearbyButton.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRCreateEventLocationSelectSearchNearbyButton()

@property (nonatomic, strong) UIImageView* currentIcon;
@property (nonatomic, strong) UIImageView* searchIcon;
@property (nonatomic, strong) UILabel* searchLabel;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRCreateEventLocationSelectSearchNearbyButton

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self currentIcon];
        [self searchIcon];
        [self searchLabel];
        [self subtitleLabel];
        [self separator];
//        [self setBackgroundImage:[UIImage imageNamed:@"linkWaterColor"] forState:UIControlStateHighlighted];
    }
    return self;
}


- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    if (highlighted) {
        self.backgroundColor = [UIColor bs_colorWithHexString:@"F5F6F7"];
    }
    
}

#pragma mark - LazyLoad

- (UIImageView*) currentIcon
{
    if (!_currentIcon)
    {
        _currentIcon = [UIImageView new];
        _currentIcon.layer.cornerRadius = 20;
        [_currentIcon setImage:[FRStyleKit imageOfLocationIcon]];
        [self addSubview:_currentIcon];
        [_currentIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@40);
            make.left.equalTo(self).offset(15);
            make.centerY.equalTo(self);
        }];
    }
    return _currentIcon;
}

- (UILabel*) searchLabel
{
    if (!_searchLabel)
    {
        _searchLabel = [UILabel new];
        [_searchLabel setText:@"Search Nearby"];
        _searchLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _searchLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        [self addSubview:_searchLabel];
        [_searchLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentIcon.mas_right).offset(10);
            make.bottom.equalTo(self.mas_centerY);
        }];
    }
    return _searchLabel;
}

- (UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        [_subtitleLabel setText:@"Current location"];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        [self addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentIcon.mas_right).offset(10);
            make.top.equalTo(self.mas_centerY).offset(3);
        }];
    }
    return _subtitleLabel;
}

- (UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

//- (UIImageView*) searchIcon
//{
//    if (!_searchIcon)
//    {
//        _searchIcon = [UIImageView new];
//        [_searchIcon setImage:[UIImageHelper image:[FRStyleKit imageOfSearchNearMeCanvas]  color:[UIColor bs_colorWithHexString:@"00B5FF"]]];
//        [self addSubview:_searchIcon];
//        [_searchIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
//            make.width.height.equalTo(@20);
//            make.right.equalTo(self).offset(-20);
//        }];
//    }
//    return _searchIcon;
//}

@end
