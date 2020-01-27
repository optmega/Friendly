//
//  FRCreateEventIconDataCell.m
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventIconDataCell.h"
#import "FRStyleKit.h"
#import "FRCreateEventViewConstants.h"


@interface FRCreateEventIconDataCell ()

@property (nonatomic, strong) UIImageView* icon;
@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UIImageView* arrowImage;
//@property (nonatomic, strong) UITextField* textField;

@property (nonatomic, strong) FRCreateEventIconDataCellViewModel* model;

@end

@implementation FRCreateEventIconDataCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10);
        [self arrowImage];
    }
    return self;
}

- (void)updateWithModel:(FRCreateEventIconDataCellViewModel*)model
{
    self.model = model;
    self.icon.image = model.icon;
    self.contentLabel.text = model.content;
    
    self.titleLabel.attributedText = model.attributedTitle;
    if ([self.titleLabel.text  isEqual: @"Time *"]) {
        self.separatorInset = UIEdgeInsetsMake(0, 450, 0, 0);
    }
    else
    {
        self.separatorInset = UIEdgeInsetsMake(0, 60, 0, 10);
    }
}


#pragma mark - Lazy Load

- (UIImageView*)icon
{
    if (!_icon)
    {
        _icon = [UIImageView new];
        _icon.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:_icon];
        
        [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(@20);
            make.left.equalTo(self.contentView).offset(20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _icon;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.icon.mas_right).offset(20);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
    }
    return _titleLabel;
}

- (UIImageView*)arrowImage
{
    if (!_arrowImage)
    {
        _arrowImage = [UIImageView new];
        _arrowImage.image = [FRStyleKit imageOfFeildChevroneCanvas];
        [self.contentView addSubview:_arrowImage];
        
        [_arrowImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
            make.width.equalTo(@20);
        }];
    }
    return _arrowImage;
}

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.textAlignment = NSTextAlignmentRight;
//        _contentLabel.adjustsFontSizeToFitWidth = YES;
        _contentLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _contentLabel.textColor = [UIColor bs_colorWithHexString:@"#8D92A0"];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrowImage.mas_left).offset(-10);
            make.centerY.equalTo(self.contentView);
            make.left.equalTo(self.contentView.mas_centerX);
            
        }];
    }
    return _contentLabel;
}




@end
