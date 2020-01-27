//
//  FRTitleGroupCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRTitleGroupCell.h"

@interface FRTitleGroupCell ()

@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation FRTitleGroupCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.separatorInset = UIEdgeInsetsMake(0, 5000, 0, 0);
    }
    return self;
}

- (void)updateWithModel:(NSString*)model
{
    self.titleLabel.text = model;
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(20);
            make.top.equalTo(self.contentView).offset(20);
        }];
    }
    return _titleLabel;
}



@end
