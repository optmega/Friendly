//
//  FRCreateEventLocationSelectTableViewCell.m
//  Friendly
//
//  Created by Jane Doe on 3/30/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventLocationSelectTableViewCell.h"
#import "UIImageView+WebCache.h"

@import GoogleMaps;

@interface FRCreateEventLocationSelectTableViewCell()

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;

@end

@implementation FRCreateEventLocationSelectTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self icon];
        [self titleLabel];
        [self subtitleLabel];
        [self separator];
        self.separator.hidden = YES;
    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if (highlighted) {
        self.contentView.backgroundColor = [UIColor bs_colorWithHexString:@"F5F6F7"];
    } else {
        self.contentView.backgroundColor = [UIColor whiteColor];
    }
}

- (void) updateCell:(FRCreateEventLocationPlaceModel*)response :(NSString*)icon :(BOOL)isSeparator
{
    self.selectedResponse = response;
    self.titleLabel.text = response.placeName;
    if ([response.days_from_last_search isEqualToString:@""]) {
        self.subtitleLabel.text = response.placeAddress;
    }
    else
    {
        self.subtitleLabel.text = [NSString stringWithFormat:@"Searched %@ days ago", response.days_from_last_search];
    }
    

//    NSURL* urlForHeader = [NSURL URLWithString:icon];
//    [self.icon sd_setImageWithURL:urlForHeader completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image1)
//        {
//            self.icon.image = image1;
//        }
//    }];
    if (isSeparator)
    {
        self.separator.hidden = NO;
    }
    else
    {
        self.separator.hidden = YES;
    }
}



#pragma mark - LazyLoad

//- (UIImageView*) icon
//{
//    if (!_icon)
//    {
//        _icon = [UIImageView new];
//        _icon.layer.cornerRadius = 20;
//        [self.contentView addSubview:_icon];
//        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.height.width.equalTo(@40);
//            make.left.equalTo(self.contentView);
//            make.centerY.equalTo(self.contentView);
//        }];
//    }
//    return _icon;
//}

- (UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView.mas_centerY).offset(-2);
        }];
    }
    return _titleLabel;
}

- (UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        [self.contentView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(5);
            make.top.equalTo(self.contentView.mas_centerY).offset(2);
            make.right.equalTo(self.contentView).offset(-2);
        }];
    }
    return _subtitleLabel;
}

- (UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end
