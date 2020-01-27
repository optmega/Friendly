//
//  FRMyProfileAddMobileIconCell.m
//  Friendly
//
//  Created by User on 23.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileAddMobileIconCell.h"
#import "FRStyleKit.h"

@interface FRMyProfileAddMobileIconCell()

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIView* separator;

@end

@implementation FRMyProfileAddMobileIconCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self icon];
        [self titleLabel];
        [self subtitleLabel];
        [self separator];
    }
    return self;
}

#pragma mark - Lazy Load

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.layer.cornerRadius = 0;
        _icon.tintColor =  [UIColor blueColor];
        _icon.image = [FRStyleKit imageOfCombinedShapeCanvas4];
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@32);
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _icon;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.text = @"Mobile (hidden)";
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.icon.mas_right).offset(10);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.icon.mas_centerY).offset(1);
        }];
    }
    return _titleLabel;
}


- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [[UIColor bs_colorWithHexString:@"606671"] colorWithAlphaComponent:0.4];
        _subtitleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(12);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.numberOfLines = 3;
        NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString: @"Only provided to guests of your hosted event.\nThis can also be turned on/off for different events\nyou are hosting"];
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        [style setLineSpacing:1.3];
        [attrString addAttribute:NSParagraphStyleAttributeName
                           value:style
                           range:NSMakeRange(0, attrString.length)];

        _subtitleLabel.attributedText = attrString;
        [self.contentView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.top.equalTo(self.icon.mas_centerY).offset(5);
            make.right.equalTo(self.titleLabel);
        }];
    }
    return _subtitleLabel;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:@"E4E6EA"]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}


@end
