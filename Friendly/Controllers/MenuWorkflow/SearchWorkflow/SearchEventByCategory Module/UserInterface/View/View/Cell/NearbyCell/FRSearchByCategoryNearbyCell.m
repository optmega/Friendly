//
//  FRSearchByCategoryNearbyCell.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryNearbyCell.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRSearchByCategoryNearbyCell()


@property (nonatomic, strong) FRSearchByCategoryNearbyCellViewModel* model;
@property (nonatomic, strong) UIImageView* iconImage;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIButton* settingButton;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRSearchByCategoryNearbyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self separator];
        [self titleLabel];
        [self separator];
        @weakify(self);
        [[self.settingButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model settingSelected];
        }];
    }
    return self;
}

- (void)updateWithModel:(FRSearchByCategoryNearbyCellViewModel*)model
{
    self.model = model;
    self.titleLabel.text = model.content;
}


- (UIImageView*)iconImage
{
    if (!_iconImage)
    {
        _iconImage = [UIImageView new];
        _iconImage.image = [UIImageHelper image:[FRStyleKit imageOfEventPreviewLocationIcon] color:[UIColor bs_colorWithHexString:@"#ADB6CE"]] ;
        _iconImage.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_iconImage];
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.centerY.equalTo(self.contentView);
            make.width.height.equalTo(@19);
        }];
    }
    return _iconImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:kFieldTextColor];
        _titleLabel.text = FRLocalizedString(@"NEARBY", nil);
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.iconImage.mas_right).offset(5);
        }];
    }
    return _titleLabel;
}

- (UIButton*)settingButton
{
    if (!_settingButton)
    {
        _settingButton = [UIButton new];
        UIImage* image = [FRStyleKit imageOfNavFilterCanvas];
        
        [_settingButton setImage:[UIImageHelper image:image color:[UIColor bs_colorWithHexString:@"#ADB6CE"]] forState:UIControlStateNormal];
        [self.contentView addSubview:_settingButton];
        [_settingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _settingButton;
}

//- (UIView*)separator
//{
//    if (!_separator)
//    {
//        _separator = [UIView new];
//        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
//        [self.contentView addSubview:_separator];
//        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.bottom.right.equalTo(self.contentView);
//            make.height.equalTo(@1);
//        }];
//    }
//    return _separator;
//}





@end
