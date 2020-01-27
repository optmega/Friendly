//
//  FRSegmentItem.m
//  Friendly
//
//  Created by Sergey Borichev on 01.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSegmentItem.h"

@interface FRSegmentItem ()

@end

@implementation FRSegmentItem

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(15);
        [self setTitleColor:[UIColor bs_colorWithHexString:@"ADB6CE"] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
        self.separator.hidden = true;
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    super.selected = selected;
//    self.separator.hidden = !selected;
    
}

#pragma mark - Lazy Load

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"7C62FE"];
        _separator.layer.cornerRadius = 1.25;
        [self addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self);
            make.height.equalTo(@2.5);
        }];
    }
    return _separator;
}

@end
