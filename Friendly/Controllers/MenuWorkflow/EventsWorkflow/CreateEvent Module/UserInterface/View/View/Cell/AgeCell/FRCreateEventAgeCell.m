//
//  FRCreateEventAgeCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventAgeCell.h"
#import "FRStyleKit.h"
#import "FRCreateEventViewConstants.h"
#import "FRCreateEventInviteFriendsViewController.h"
#import "FRCreateEventCategoryViewController.h"


@interface FRCreateEventAgeCell ()

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UIImageView* image;
@property (nonatomic, strong) FRCreateEventAgeCellViewModel* model;

@end

@implementation FRCreateEventAgeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
        [self icon];
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventAgeCellViewModel*)model
{
    self.model = model;
    self.titleLabel.attributedText = [model attributedTitle];
    
    self.dataLabel.text = model.contentTitle;
    
    if (model.cellType == FRAgeCellTypeImage)
    {
        self.image.image = [self _genderImage:model.gender];
    }
    
    self.dataLabel.hidden = model.type == FRCreateEventCellTypeGender;
    self.image.hidden = !self.dataLabel.hidden;
}

- (UIImage*)_genderImage:(FRGenderType)gender
{
    [self.image mas_updateConstraints:^(MASConstraintMaker *make) {
        CGFloat width = gender == FRGenderTypeAll ? 70 : 30;
        make.width.equalTo(@(width));
    }];
    switch (gender) {
        case FRGenderTypeAll: {
            return [FRStyleKit imageOfSexBoth];
            break;
        }
        case FRGenderTypeMale: {
            return [FRStyleKit imageOfSexMaleOnCanvas];

            break;
        }
        case FRGenderTypeFemale: {
            return [FRStyleKit imageOfSexFemaleOnCanvas];
            
            break;
        }
    }
    return nil;
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
    }
    return _titleLabel;
}

- (UILabel*)dataLabel
{
    if (!_dataLabel)
    {
        _dataLabel = [UILabel new];
        _dataLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _dataLabel.textAlignment = NSTextAlignmentRight;
        _dataLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
        _dataLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_dataLabel];
        
        [_dataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.icon.mas_left).offset(-5);
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _dataLabel;
}

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.equalTo(@20);
        }];
    }
    return _icon;
}

- (UIImageView*)image
{
    if (!_image)
    {
        _image = [UIImageView new];
        _image.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_image];
        
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.icon.mas_left).offset(-5);
            make.height.equalTo(@30);
        }];
    }
    return _image;
}

@end
