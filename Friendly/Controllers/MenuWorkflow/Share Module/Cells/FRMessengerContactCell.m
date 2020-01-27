//
//  FRMessengerContactCell.m
//  Friendly
//
//  Created by User on 28.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessengerContactCell.h"

@interface FRMessengerContactCell()

@property (strong, nonatomic) UIImageView* userPhoto;
@property (strong, nonatomic) UILabel* userInfoLabel;
@property (strong, nonatomic) UIImageView* userIcon;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UIButton* checkView;

@end

@implementation FRMessengerContactCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self userInfoLabel];
        [self userPhoto];
        [self separator];
        [self checkView];
        [self userIcon];
    }
    return self;
}

#pragma mark - LazyLoad

-(UIImageView*) userPhoto
{
    if (!_userPhoto)
    {
        _userPhoto = [UIImageView new];
        _userPhoto.layer.cornerRadius = 20;
        [_userPhoto setBackgroundColor:[UIColor blackColor]];
        [self.contentView addSubview:_userPhoto];
        [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@40);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
        }];
    }
    return _userPhoto;
}

-(UILabel*) userInfoLabel
{
    if (!_userInfoLabel) {
        _userInfoLabel = [UILabel new];
        [_userInfoLabel setText:@"Name, age"];
        _userInfoLabel.font = FONT_PROXIMA_NOVA_MEDIUM(18);
        [_userInfoLabel setTextColor:[UIColor bs_colorWithHexString:KTextTitleColor]];
        [self.contentView addSubview:_userInfoLabel];
        [_userInfoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.userPhoto.mas_right).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _userInfoLabel;
}

-(UIImageView *)userIcon
{
    if (!_userIcon)
    {
        _userIcon = [UIImageView new];
        _userIcon.layer.cornerRadius = 8;
        [_userIcon setBackgroundColor:[UIColor blueColor]];
        [self.userPhoto addSubview:_userIcon];
        [_userIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@16);
            make.bottom.equalTo(self.userPhoto);
            make.right.equalTo(self.userPhoto);
        }];
    }
    return _userIcon;
}

-(UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UIButton*)checkView
{
    if (!_checkView)
    {
        _checkView = [UIButton new];
        _checkView.layer.borderWidth = 1;
        _checkView.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _checkView.layer.cornerRadius = 10;
        [self.contentView addSubview:_checkView];
        [_checkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@20);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
    }
    return _checkView;
}

@end
