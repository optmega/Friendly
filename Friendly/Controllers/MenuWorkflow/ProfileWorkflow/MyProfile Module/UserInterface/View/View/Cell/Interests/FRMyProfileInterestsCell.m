//
//  FRMyProfileInterestsCell.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileInterestsCell.h"
#import "BSTagView.h"

@interface FRMyProfileInterestsCell ()

@property (nonatomic, strong) UIView* subView;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) BSTagView* tagView;
@property (nonatomic, strong) FRMyProfileInterestsCellViewModel* model;
@end




@implementation FRMyProfileInterestsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)updateWithModel:(FRMyProfileInterestsCellViewModel*)model
{
    self.model = model;
    [self.tagView updateWithTags:model.tags];
    self.titleLabel.text = model.title;
}

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
            make.top.equalTo(self.contentView).offset(25);
            make.height.equalTo(@20);
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
        }];
    }
    return _titleLabel;
}

- (BSTagView*)tagView
{
    if (!_tagView)
    {
        _tagView = [BSTagView new];
        [self addSubview:_tagView];
        
        [_tagView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(15);
            make.left.equalTo(self.contentView).offset(18);
            make.right.equalTo(self.contentView).offset(-18);
            make.bottom.equalTo(self.contentView);
        }];
    }
    return _tagView;
}

@end
