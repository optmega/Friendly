//
//  FREventImageSelectHeaderCell.m
//  Friendly
//
//  Created by User on 08.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectHeaderCell.h"

@interface FREventImageSelectHeaderCell()

@property (strong, nonatomic) UILabel* selectLabel;


@end

@implementation FREventImageSelectHeaderCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.autoresizesSubviews = YES;
        [self selectLabel];
    }
    return self;
}


-(UILabel*) selectLabel
{
    if (!_selectLabel)
    {
        _selectLabel = [UILabel new];
        [_selectLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(12)];
        [_selectLabel setText:@"SELECT AN IMAGE"];
        [_selectLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self.contentView addSubview:_selectLabel];
        [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(20);
        }];
    }
    return _selectLabel;
}


@end
