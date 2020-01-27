//
//  FRCreateEventAddImageCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventAddImageCell.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRCreateEventAddImageCell ()

@property (nonatomic, strong) UIImageView* photo;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIButton* uploadButton;
@property (nonatomic, strong) UIButton* saveButton;
@property (nonatomic, strong) UIButton* changeUserPhotoButton;
@property (nonatomic, strong) FRCreateEventAddImageCellViewModel* model;
@property (nonatomic, strong) UIImageView* overlayImage;

@end

@implementation FRCreateEventAddImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self photo];
        [self overlayImage];
        [self icon];
        self.changeUserPhotoButton.hidden = YES;
        @weakify(self);
        [[self.uploadButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model uploadPhoto];
        }];
        [[self.changeUserPhotoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model uploadPhoto];
        }];
        [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model close];
        }];
        
        [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model save];
        }];
        self.backButton.hidden = YES;// this button added above tableView
        self.saveButton.hidden = YES; // this button added above tableView
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventAddImageCellViewModel*)model
{
    self.model = model;
    [self.model updateImage:self.photo];
    if (![model.photo isEqual:[FRStyleKit imageOfCreateEventPlaceholder]])
    {
        self.photo.image = model.photo;
        self.icon.hidden = YES;
        self.titleLabel.hidden = YES;
        self.uploadButton.hidden = YES;
        self.changeUserPhotoButton.hidden = NO;
        return;
    }
    else
    {
        self.photo.image = model.photo;
        self.overlayImage.hidden = YES;
        return;
    }
//    [self.model updateImage:self.photo];

}


#pragma mark - Lazy Load

- (UIImageView*)photo
{
    if (!_photo)
    {
        _photo = [UIImageView new];
        _photo.image = [FRStyleKit imageOfCreateEventPlaceholder];
        _photo.contentMode = UIViewContentModeScaleAspectFill;
        _photo.clipsToBounds = true;
        [self.contentView addSubview:_photo];
        
        [_photo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _photo;
}

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.image = [FRStyleKit imageOfCircleCreateEvent];
        _icon.layer.cornerRadius = 30;
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@60);
            make.centerX.equalTo(self.contentView);
            make.bottom.equalTo(self.titleLabel.mas_top).offset(-20);
        }];
    }
    return _icon;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.text = FRLocalizedString(@"ADD A CUSTOM IMAGE", nil);
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.font = FONT_VENTURE_EDDING_BOLD(34);
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_centerY).offset(-10);
            make.left.equalTo(self.contentView).offset(40);
            make.right.equalTo(self.contentView).offset(-40);
        }];
    }
    return _titleLabel;
}

//- (UILabel*)subtitleLabel
//{
//    if (!_subtitleLabel)
//    {
//        _subtitleLabel = [UILabel new];
//        _subtitleLabel.text = FRLocalizedString(@"GOOGLE PLACES AS DEFAULT IMAGE", nil);
//        _subtitleLabel.textColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
//        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
//        _subtitleLabel.font = FONT_SF_DISPLAY_BOLD(12);
//        _subtitleLabel.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:_subtitleLabel];
//        
//        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
//            make.left.equalTo(self.contentView).offset(50);
//            make.right.equalTo(self.contentView).offset(-50);
//        }];
//    }
//    return _subtitleLabel;
//}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavCloseCanvas] color:[[UIColor bs_colorWithHexString:@"#170B47"]colorWithAlphaComponent:0.8]] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        _backButton.backgroundColor = [[UIColor bs_colorWithHexString:@"#170B47"]colorWithAlphaComponent:0.8];
        _backButton.layer.cornerRadius = 15;
        [self.contentView addSubview:_backButton];
        
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@30);
            make.top.equalTo(@30);
            make.left.equalTo(@15);
        }];
    }
    return _backButton;
}

- (UIButton*)saveButton
{
    if (!_saveButton)
    {
        _saveButton = [UIButton new];
        [_saveButton setTitle:FRLocalizedString(@"    Save    ", nil) forState:UIControlStateNormal];
        _saveButton.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _saveButton.layer.cornerRadius = 15;
        [self.contentView addSubview:_saveButton];
        [_saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(30);
            make.height.equalTo(@30);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return _saveButton;
}

- (UIButton*)uploadButton
{
    if (!_uploadButton)
    {
        _uploadButton = [UIButton new];
        _uploadButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_uploadButton setImage:[FRStyleKit imageOfUploadCanvas] forState:UIControlStateNormal];
        [_uploadButton setTitle:FRLocalizedString(@"Upload", nil) forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_uploadButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _uploadButton.titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(14);
        _uploadButton.imageEdgeInsets = UIEdgeInsetsMake(-5, -15, -5, -5);
        _uploadButton.layer.cornerRadius = 17;
        [self.contentView addSubview:_uploadButton];
        
        [_uploadButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
            make.width.equalTo(@105);
            make.height.equalTo(@35);
        }];
    }
    return _uploadButton;
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
        
        [self.contentView addSubview:_changeUserPhotoButton];
        
        [_changeUserPhotoButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@78);
            make.height.equalTo(@27);
            make.bottom.equalTo(@-15);
            make.right.equalTo(@-15);
        }];
    }
    return _changeUserPhotoButton;
}

-(UIImageView*)overlayImage
{
    if (!_overlayImage)
    {
        _overlayImage = [UIImageView new];
        [_overlayImage setImage:[UIImage imageNamed:@"over-normal-event.png"]];
        [self.photo addSubview:_overlayImage];
        [_overlayImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.photo);
        }];
    }
    return _overlayImage;
}

@end
