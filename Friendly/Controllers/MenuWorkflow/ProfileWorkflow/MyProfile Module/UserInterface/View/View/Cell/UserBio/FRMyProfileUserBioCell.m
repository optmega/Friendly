//
//  FRMyProfileUserBioCell.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileUserBioCell.h"

@interface FRMyProfileUserBioCell ()

@property (nonatomic, strong) UILabel* contentLabel;

@property (nonatomic, strong) FRMyProfileUserBioCellViewModel* model;

@end

@implementation FRMyProfileUserBioCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
    }
    return self;
}

- (void)updateWithModel:(FRMyProfileUserBioCellViewModel*)model
{
    self.model = model;
    self.contentLabel.attributedText = [model attributedString];
}


#pragma mark - Lazy Load

- (UILabel*)contentLabel
{
    if (!_contentLabel)
    {
        _contentLabel = [UILabel new];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = FONT_SF_DISPLAY_REGULAR(17);
        _contentLabel.textColor = [UIColor bs_colorWithHexString:@"606671"];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.right.equalTo(self.contentView).offset(-17);
            make.top.equalTo(self.contentView).offset(30);
            make.bottom.equalTo(self.contentView).offset(-30);
        }];
    }
    return _contentLabel;
}

@end
