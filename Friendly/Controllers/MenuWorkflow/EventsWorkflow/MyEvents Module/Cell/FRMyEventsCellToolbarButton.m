//
//  FRMyEventsCellToolbarButton.m
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCellToolbarButton.h"

@interface FRMyEventsCellToolbarButton()


@end

@implementation FRMyEventsCellToolbarButton

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        self.frame = CGRectMake(0, 0, 35, 35);
        [self image];
        [self title];
    }
    return self;
}


#pragma mark - LazyLoad

- (UIImageView*) image
{
    if (!_image)
    {
        _image = [UIImageView new];
        [self addSubview:_image];
        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.centerX.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(@22);
        }];
    }
    return _image;
}

- (UILabel*) title
{
    if (!_title)
    {
        _title = [UILabel new];
        [_title setTextColor:[UIColor bs_colorWithHexString:@"#ADB6CE"]];
        [_title setFont:FONT_SF_DISPLAY_MEDIUM(12)];
        [self addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.bottom.equalTo(self);
            make.top.equalTo(self.image.mas_bottom);
        }];
    }
    return _title;
}

@end
