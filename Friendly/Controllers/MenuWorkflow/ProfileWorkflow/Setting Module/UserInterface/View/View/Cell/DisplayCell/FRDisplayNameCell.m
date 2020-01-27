//
//  FRDisplayNameCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRDisplayNameCell.h"
#import "FRStyleKit.h"

@interface FRDisplayNameCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UILabel* contenLabel;
@property (nonatomic, strong) UIImageView* arrowImage;

@end

@implementation FRDisplayNameCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 20, 0, 20);
    }
    return self;
}

- (void)updateWithModel:(FRDisplayNameCellViewModel*)model
{
    self.titleLabel.text = model.title;
    self.subtitleLabel.text = model.subtitle;
    self.contenLabel.text = model.content;
}

- (void)setTitleColor:(UIColor*)color
{
    self.titleLabel.textColor = color;
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(20);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
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
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_centerY).offset(16);
            make.left.equalTo(self.contentView).offset(20);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _subtitleLabel;
}

- (UILabel*)contenLabel
{
    if (!_contenLabel)
    {
        _contenLabel = [UILabel new];
        _contenLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _contenLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_contenLabel];
        
        [_contenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLabel);
            make.right.equalTo(self.arrowImage.mas_left).offset(-5);
            make.width.equalTo(@120);
        }];
    }
    return _contenLabel;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_arrowImage];
        
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.titleLabel);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.equalTo(@20);
        }];
    }
    return _arrowImage;
}
@end