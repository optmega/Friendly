//
//  FRProfileUserPhotoCell.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileUserPhotoCell.h"
#import "FRStyleKit.h"

static CGFloat const kLeftOffset = 10;
static CGFloat const kUserPhotoHeight = 140;

@interface FRProfileUserPhotoCell ()

@property (nonatomic, strong) UIView* whitePlace;

@end

@implementation FRProfileUserPhotoCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self whitePlace];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self settingButton];
        [self userPhoto];
//        [self saveEditButton];
//        self.userWallPhoto.image = [UIImage imageNamed:@"Questionair - header"];
        
//        [self.saveEditButton setTitle:FRLocalizedString(@"Save", nil) forState:UIControlStateNormal];
        
        self.saveEditButton.hidden = YES;
        
        [self.contentView bringSubviewToFront:self.workFieldView];
        [self.contentView bringSubviewToFront:self.userPhoto];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.userWallPhoto.backgroundColor  = [UIColor clearColor];
    }
    return self;
}

- (UIView*)whitePlace
{
    if (!_whitePlace)
    {
        _whitePlace = [UIView new];
        _whitePlace.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_whitePlace];
        [_whitePlace mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(1);
            make.top.equalTo(self.contentView).offset(250);
        }];
    }
    return _whitePlace;
}

- (UIImageView*)userWallPhoto
{
    if (!_userWallPhoto)
    {
        _userWallPhoto = [UIImageView new];
        _userWallPhoto.userInteractionEnabled = YES;
        _userWallPhoto.contentMode = UIViewContentModeScaleToFill;
        _userWallPhoto.clipsToBounds = YES;
        [self.contentView addSubview:_userWallPhoto];
        
        [_userWallPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.contentView);
            make.height.equalTo(@200);
        }];
    }
    return _userWallPhoto;
}

- (UIButton*)saveEditButton
{
    if (!_saveEditButton)
    {
        _saveEditButton = [UIButton new];
        _saveEditButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.6];
        _saveEditButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _saveEditButton.layer.cornerRadius = 17.5;
        [_saveEditButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveEditButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.userWallPhoto addSubview:_saveEditButton];
        
        [_saveEditButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@35);
            make.width.equalTo(@77);
            make.right.equalTo(self.userWallPhoto).offset(-kLeftOffset);
            make.top.equalTo(self.userWallPhoto).offset(30);
        }];
    }
    return _saveEditButton;
}


- (UIImageView*)userPhoto
{
    if (!_userPhoto)
    {
        _userPhoto = [UIImageView new];
        _userPhoto.image = [FRStyleKit imageOfDefaultAvatar];
        _userPhoto.backgroundColor = [UIColor whiteColor];
        _userPhoto.userInteractionEnabled = YES;
        _userPhoto.contentMode = UIViewContentModeScaleAspectFill;
//        _userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
        _userPhoto.backgroundColor = [UIColor whiteColor];
        _userPhoto.clipsToBounds = YES;
//        _userPhoto.layer.borderWidth = 4.5;
        _userPhoto.layer.cornerRadius = kUserPhotoHeight / 2;
        
        
        UIView* borderView = [UIView new];
        borderView.backgroundColor = [UIColor whiteColor];
        borderView.layer.cornerRadius = (kUserPhotoHeight + 9) / 2;
        borderView.layer.zPosition = 2;
        borderView.userInteractionEnabled = true;
        [self.contentView addSubview:borderView];
        
        [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.centerY.equalTo(self.contentView.mas_top).offset(147);
            make.height.width.equalTo(@(kUserPhotoHeight + 9));
        }];
        
        [borderView addSubview:_userPhoto];
        
        [_userPhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(borderView);
            make.height.width.equalTo(@(kUserPhotoHeight));
        }];
        
    }
    return _userPhoto;
}

- (UIView*)workFieldView
{
    if (!_workFieldView)
    {
        _workFieldView = [UIView new];
        _workFieldView.layer.cornerRadius = 5;
        _workFieldView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_workFieldView];
        
        [_workFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(147);
            make.left.equalTo(self.contentView).offset(kLeftOffset);
            make.right.equalTo(self.contentView).offset(-kLeftOffset);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _workFieldView;
}

- (UIButton*)settingButton
{
    if (!_settingButton)
    {
        _settingButton = [UIButton new];
        _settingButton.layer.cornerRadius = 10;
        [self.workFieldView addSubview:_settingButton];
        
        [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.workFieldView).offset(20);
            make.right.equalTo(self.workFieldView).offset(-20);
            make.height.width.equalTo(@20);
        }];
    }
    return _settingButton;
}

- (UILabel*)usernameLabel
{
    if (!_usernameLabel)
    {
        _usernameLabel = [UILabel new];
        _usernameLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _usernameLabel.font = FONT_PROXIMA_NOVA_MEDIUM(29);
        _usernameLabel.textAlignment = NSTextAlignmentCenter;
        [self.workFieldView addSubview:_usernameLabel];
        
        [_usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userPhoto.mas_bottom);
            make.left.equalTo(self.workFieldView).offset(kLeftOffset);
            make.right.equalTo(self.workFieldView).offset(-kLeftOffset);
        }];
    }
    return _usernameLabel;
}


@end
