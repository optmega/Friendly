//
//  FRMyProfileWhyAreYouCell.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileWhyAreYouCell.h"

@interface FRMyProfileWhyAreYouCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@property (nonatomic, strong) FRMyProfileWhyAreYouCellViewModel* model;

@end

@implementation FRMyProfileWhyAreYouCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self subtitleLabel];
    }
    return self;
}

- (void)updateWithModel:(FRMyProfileWhyAreYouCellViewModel*)model
{
    self.titleLabel.text = model.title;
    self.subtitleLabel.attributedText = [model attributedString];
    [self.subtitleLabel sizeToFit];
    
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];

        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(5);
            make.height.equalTo(@20);
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-15);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"606671"];
        _subtitleLabel.font = FONT_SF_DISPLAY_THIN(17);
        _subtitleLabel.numberOfLines = 0;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    return _subtitleLabel;
}

@end
