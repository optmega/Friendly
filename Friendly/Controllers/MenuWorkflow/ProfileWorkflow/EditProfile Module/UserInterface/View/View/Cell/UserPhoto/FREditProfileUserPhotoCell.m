//
//  FREditProfileUserPhotoCell.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREditProfileUserPhotoCell.h"
#import "FRStyleKit.h"

@interface FREditProfileUserPhotoCell ()

@property (nonatomic, strong) UIButton* changeUserPhotoButton;
@property (nonatomic, strong) UIButton* changeWallPhotoButton;
@property (nonatomic, strong) FREditProfileUserPhotoCellViewModel* model;
@property (nonatomic, strong) UIButton* changePhoto;
@end

@implementation FREditProfileUserPhotoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        @weakify(self);
        [[self.changeUserPhotoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model changeUserPhoto];
        }];
        
        [[self.changeWallPhotoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model changeWallPhoto];
        }];
        
        [[self.saveEditButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model saveSelected];
        }];

        [[self.settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model settingSelected];
        }];
        self.settingButton.hidden = YES;
        
        [self.settingButton setImage:[FRStyleKit imageOfFill1Canvas2] forState:UIControlStateNormal];
        
        [self.contentView bringSubviewToFront:self.changeUserPhotoButton];
        [self changePhoto];

    }
    return self;
}


- (void)updateWithModel:(FREditProfileUserPhotoCellViewModel*)model
{
    self.model = model;
    self.usernameLabel.text = self.model.userName;
    
    self.model.userPhotoImage ? self.userPhoto.image = self.model.userPhotoImage :
         [self.model updateUserPhoto:self.userPhoto];
    
    [self.userPhoto bringSubviewToFront:self.changeUserPhotoButton];
    
}

#pragma mark - Lazy Load

- (UIButton*)changeWallPhotoButton
{
    if (!_changeWallPhotoButton)
    {
        _changeWallPhotoButton = [UIButton new];
        [_changeWallPhotoButton setTitle:FRLocalizedString(@"Change", nil) forState:UIControlStateNormal];
        _changeWallPhotoButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
        _changeWallPhotoButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        [_changeWallPhotoButton setImage:[FRStyleKit imageOfUploadCanvas] forState:UIControlStateNormal];
        _changeWallPhotoButton.layer.cornerRadius = 13.5;
        _changeWallPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        [_changeWallPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeWallPhotoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];

        [self.userWallPhoto addSubview:_changeWallPhotoButton];
        
        [_changeWallPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.userWallPhoto).offset(-15);
            make.bottom.equalTo(self.workFieldView.mas_top).offset(-15);
            make.height.equalTo(@27);
            make.width.equalTo(@78);
        }];
    }
    return _changeWallPhotoButton;
}

- (UIButton*)changeUserPhotoButton
{
    if (!_changeUserPhotoButton)
    {
        _changeUserPhotoButton = [UIButton new];
        [_changeUserPhotoButton setTitle:FRLocalizedString(@"Change", nil) forState:UIControlStateNormal];
        _changeUserPhotoButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
        _changeUserPhotoButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        [_changeUserPhotoButton setImage:[FRStyleKit imageOfUploadCanvas] forState:UIControlStateNormal];
        _changeUserPhotoButton.layer.cornerRadius = 13.5;
        [_changeUserPhotoButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changeUserPhotoButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _changeUserPhotoButton.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);

//        _changeUserPhotoButton.layer.zPosition = 125;
        [self.userWallPhoto addSubview:_changeUserPhotoButton];
        
        [_changeUserPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@78);
            make.height.equalTo(@27);
            make.center.equalTo(self.userPhoto);
        }];
    }
    return _changeUserPhotoButton;
}

- (UIButton*)changePhoto
{
    if (!_changePhoto)
    {
        _changePhoto = [UIButton new];
        [_changePhoto setTitle:FRLocalizedString(@"Change", nil) forState:UIControlStateNormal];
        _changePhoto.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
        _changePhoto.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(12);
        [_changePhoto setImage:[FRStyleKit imageOfUploadCanvas] forState:UIControlStateNormal];
        _changePhoto.layer.cornerRadius = 13.5;
        [_changePhoto setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_changePhoto setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _changePhoto.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
        
        //        _changeUserPhotoButton.layer.zPosition = 125;
        [self.userPhoto addSubview:_changePhoto];
        
        [_changePhoto mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@78);
            make.height.equalTo(@27);
            make.center.equalTo(self.userPhoto);
        }];
    }
    return _changePhoto;
}

@end
