//
//  FRCreateEventInformationCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInformationCell.h"
#import "FRStyleKit.h"


@interface FRCreateEventInformationCell ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIButton* blockButton;

@property (nonatomic, strong) FRCreateEventInformationCellViewModel* model;

@end

@implementation FRCreateEventInformationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
        [self titleLabel];
        [self subtitleLabel];
        [self blockButton];
       
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventInformationCellViewModel*)model
{
    self.model = model;
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.text = FRLocalizedString(@"Event Information", nil);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(37);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9ca0ab"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        _subtitleLabel.text = FRLocalizedString(@"Only visible once you accept their request", nil);
        
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
            make.right.equalTo(self.blockButton.mas_left).offset(-10);
        }];
    }
    return _subtitleLabel;
}

- (UIButton*)blockButton
{
    if (!_blockButton)
    {
        _blockButton = [UIButton new];
        [_blockButton setImage:[FRStyleKit imageOfPrivateInfoCanvas] forState:UIControlStateNormal];
        [self.contentView addSubview:_blockButton];
        
        [_blockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@36);
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _blockButton;
}


@end