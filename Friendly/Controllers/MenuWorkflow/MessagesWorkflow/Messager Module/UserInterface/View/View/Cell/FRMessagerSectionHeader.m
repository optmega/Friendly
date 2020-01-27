//
//  FRMessagerSectionHeader.m
//  Friendly
//
//  Created by Dmitry on 17.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagerSectionHeader.h"

@interface FRMessagerSectionHeader ()

@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation FRMessagerSectionHeader

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    self.titleLabel.text = @"MESSAGES";
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(12);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"A1A5AF"];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(20);
            make.bottom.equalTo(self).offset(-10);
        }];
    }
    return _titleLabel;
}

@end
