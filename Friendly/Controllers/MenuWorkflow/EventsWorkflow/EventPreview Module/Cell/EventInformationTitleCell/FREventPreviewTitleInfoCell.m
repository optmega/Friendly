//
//  FRInformationTitleTableViewCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewTitleInfoCell.h"

@interface FREventPreviewTitleInfoCell()

@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* subtitleLabel;
@property (strong, nonatomic) UIView* separator;
@end

@implementation FREventPreviewTitleInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self titleLabel];
        [self subtitleLabel];
        [self separator];

    }
    return self;
}

-(void)updateTitleInfoCellWithAttendingStatus
{
    self.subtitleLabel.hidden = YES;
}
#pragma mark - LazyLoad

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"Event information"];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(20)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(40);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _titleLabel;
}

-(UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        [_subtitleLabel setText:@"Visible once the host accepts your request to join"];
        [_subtitleLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [_subtitleLabel setFont:FONT_SF_DISPLAY_REGULAR(14)];
        [self.contentView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
            make.left.equalTo(self.contentView).offset(15);
        }];
        
    }
    return _subtitleLabel;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];     
    }
    return _separator;
}

@end