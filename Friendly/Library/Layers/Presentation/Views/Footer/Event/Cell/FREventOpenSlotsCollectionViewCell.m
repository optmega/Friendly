//
//  FREventOpenSlotsCollectionViewCell.m
//  Friendly
//
//  Created by Sergey Borichev on 16.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventOpenSlotsCollectionViewCell.h"

@interface FREventOpenSlotsCollectionViewCell ()

@property (nonatomic, strong) UILabel* titleLabel;

@end

@implementation FREventOpenSlotsCollectionViewCell


- (void)updateWithModel:(NSInteger)countSlots
{
    self.titleLabel.text = [NSString stringWithFormat:@"  %ld open  ", (long)countSlots];
}

#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.layer.borderColor = [UIColor bs_colorWithHexString:@"E8EBF1"].CGColor;
        _titleLabel.layer.borderWidth = 1;
        _titleLabel.layer.cornerRadius = 10;
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#979CA8"];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(10);
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.height.equalTo(@20);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _titleLabel;
}
@end
