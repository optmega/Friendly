//
//  DistanceLabel.m
//  Friendly
//
//  Created by Jane Doe on 3/15/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRDistanceLabel.h"
#import "FRStyleKit.h"

@interface FRDistanceLabel()

@property (strong, nonatomic) UIImageView* distanceIcon;

@end

@implementation FRDistanceLabel

//- (void)drawTextInRect:(CGRect)rect {
//    UIEdgeInsets insets = {0, 20, 0, 0};
//    [self distanceIcon];
//    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, insets)];
//}
//

#define padding UIEdgeInsetsMake(5, 5, 5, 5)

- (void)drawTextInRect:(CGRect)rect {
//    [self distanceIcon];
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, padding)];
}

- (CGSize) intrinsicContentSize {
    CGSize superContentSize = [super intrinsicContentSize];
    CGFloat width = superContentSize.width + padding.left + padding.right;
    CGFloat height = superContentSize.height + padding.top + padding.bottom;
    return CGSizeMake(width, height);
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize superSizeThatFits = [super sizeThatFits:size];
    CGFloat width = superSizeThatFits.width + padding.left + padding.right;
    CGFloat height = superSizeThatFits.height + padding.top + padding.bottom;
    return CGSizeMake(width, height);
}


- (UIImageView*)distanceIcon
{
    if (!_distanceIcon)
    {
        _distanceIcon = [UIImageView new];
        _distanceIcon.image = [FRStyleKit imageOfFeildLocationCanvasWhite];
        _distanceIcon.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_distanceIcon];
        [_distanceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self);
            make.left.equalTo(self).offset(4);
            make.top.equalTo(self).offset(4);
            make.bottom.equalTo(self).offset(-4);
            make.width.equalTo(@15);
            
        }];
    }
    return _distanceIcon;
}

@end
