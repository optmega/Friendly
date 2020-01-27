//
//  Created by Sergey Borichev on 26.03.16.
//  Copyright © 2016 Sergey Borichev. All rights reserved.
//

#import "BSTagView.h"
#import "Interest.h"


#define RGB(r, g, b) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

@interface BSTagLabel : UILabel

@end

@interface BSTagView ()

@property (nonatomic, strong) NSArray* tags;
@end

static CGFloat const kDefaultLabelHeight = 30;

@implementation BSTagView

+ (CGFloat)heightTagViewWithWidth:(CGFloat)width tags:(NSArray*)tags
{
    BSTagView* tagView = [[BSTagView alloc]initWithFrame:CGRectMake(0, 0, width, 100)];
    [tagView updateWithTags:tags];
    [tagView layoutSubviews];
    return (tagView.countStack + 1) * (tagView.labelHeight + 5);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [self _update];
}

- (void)updateWithTags:(NSArray*)tags
{
    self.tags = tags;
    [self _update];

}

- (void)_update
{
    for (UIView* view in [self tagsLabelArray])
    {
        [self addSubview:view];
    }
}

- (NSArray*)tagsLabelArray
{
    const CGFloat width = self.bounds.size.width;
    CGFloat widthStack = 0;
    self.countStack = 0;
    
    NSMutableArray* tagArray = [NSMutableArray array];
    for (Interest* interest in self.tags)
    {
        NSString *tag = interest.title;
        BSTagLabel* label = [BSTagLabel new];
        label.text = [NSString stringWithFormat:@"#%@", tag];
        label.font = FONT_PROXIMA_NOVA_MEDIUM(15);
        label.textColor = [UIColor blackColor];
        label.layer.cornerRadius = 5;
        label.layer.masksToBounds = YES;
//        label.layer.borderWidth = 1;
//        label.layer.borderColor = RGB(210,210,210).CGColor;
        [label sizeToFit];
        label.backgroundColor = RGB(244,245,249);
        CGRect labelFrame = label.bounds;
        labelFrame.size.height = self.labelHeight;
        
        if ([interest.isMutual boolValue]) {
//            label.layer.borderColor = RGB(96,102,201).CGColor;
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        }
        
        if (labelFrame.size.width > width)
        {
            labelFrame.size.width = width;
        }
        if (widthStack + labelFrame.size.width  >= width)
        {
            widthStack = 0;
            self.countStack++;
        }
        
        labelFrame.origin.x = widthStack;
        labelFrame.origin.y = (self.labelHeight + 5) * self.countStack;
        widthStack += (labelFrame.size.width + 5);
        label.frame = labelFrame;
        [tagArray addObject:label];
    }
    return tagArray;
}


#pragma mark - Lazy Load

- (CGFloat)labelHeight
{
    if (!_labelHeight)
    {
        _labelHeight = kDefaultLabelHeight;
    }
    return  _labelHeight;
}

@end



@implementation BSTagLabel

#define padding UIEdgeInsetsMake(0, 10, 0, 10)

- (void)drawTextInRect:(CGRect)rect {

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
@end
