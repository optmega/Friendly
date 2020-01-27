//
//  FRSearchPeopleInviteCell.m
//  Friendly
//
//  Created by Sergey Borichev on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchPeopleInviteCell.h"
#import "FRStyleKit.h"

@interface FRSearchPeopleInviteCell ()

@property (nonatomic, strong) UIImageView* iconImage;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIImageView* arrowImage;

@end

@implementation FRSearchPeopleInviteCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        [self iconImage];
        [self titleLabel];
        [self subtitleLabel];
        [self arrowImage];
        
        

    }
    return self;
}

- (void)updateWithModel:(FRSearchPeopleInviteCellViewModel*)model
{
    
}

#pragma mark - Lazy Load

- (UIImageView*)iconImage
{
    if (!_iconImage)
    {
        _iconImage = [UIImageView new];
        _iconImage.image = [FRStyleKit imageOfFeildFacebookCanvasGray];
        [self.contentView addSubview:_iconImage];
        
        [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(34);
            make.left.equalTo(self.contentView).offset(15);
            make.width.height.equalTo(@30);
        }];
    }
    return _iconImage;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.text = FRLocalizedString(@"Invite your friends", nil);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.iconImage.mas_centerY).offset(3);
            make.left.equalTo(self.iconImage.mas_right).offset(13);
            make.right.equalTo(self.arrowImage.mas_left).offset(-20);
        }];
    }
    return _titleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _subtitleLabel.text = FRLocalizedString(@"and share instant access between your events", nil);
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.iconImage.mas_centerY).offset(3);
            make.left.equalTo(self.iconImage.mas_right).offset(13);
            make.right.equalTo(self.arrowImage.mas_left).offset(-20);
        }];
    }
    return _subtitleLabel;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvasThink];
        [self.contentView addSubview:_arrowImage];
        
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-5);
            make.width.equalTo(@20);
            make.centerY.equalTo(self.iconImage);
        }];
    }
    return _arrowImage;
}

@end
