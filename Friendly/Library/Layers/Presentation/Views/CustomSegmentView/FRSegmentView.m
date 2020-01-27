//
//  FRSegmentView.m
//  Friendly
//
//  Created by Sergey Borichev on 01.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSegmentView.h"
#import "FRSegmentItem.h"

@interface FRSegmentView ()

@property (nonatomic, strong) FRSegmentItem* item1;
@property (nonatomic, strong) FRSegmentItem* item2;
@property (nonatomic, strong) FRSegmentItem* item3;
@property (nonatomic, assign) CGFloat buttonWidth;

@property (nonatomic, strong) UIView* selectLine;

@end

static CGFloat const sideOffset = 30;
 

@implementation FRSegmentView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.buttonWidth = ([UIScreen mainScreen].bounds.size.width - 100) / 3;
        
        CGRect rectFrame = CGRectMake(sideOffset, 40 - 2.5, self.buttonWidth, 2.5);
        
        [self item2];
        [self.item2.separator setBackgroundColor:[UIColor bs_colorWithHexString:kFriendlyBlueColor]];
        self.item2.separator.hidden = YES;
        [self item3];
        [self.item3.separator setBackgroundColor:[UIColor bs_colorWithHexString:kFriendlyPinkColor]];
        self.item3.separator.hidden = YES;
        self.item1.selected = YES;
        
        self.selectLine = [[UIView alloc]initWithFrame:rectFrame];
        self.selectLine.backgroundColor = self.item1.separator.backgroundColor;
        self.selectLine.layer.cornerRadius = 2;
        [self addSubview:_selectLine];
    }
    return self;
}


- (void)selectedItem:(UIButton*)sender
{
    NSArray* items = @[self.item1, self.item2, self.item3];
    [items enumerateObjectsUsingBlock:^(FRSegmentItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    
    [self.delegate selectedSegmentIndex:sender.tag];
    sender.selected = YES;
    
    CGRect selectedFrame = CGRectZero;
    UIColor* selectedColor = [UIColor clearColor];
    
    switch (sender.tag) {
        case FRSegmentTypeFeatured:
            
            selectedFrame = self.item1.separator.frame;
            selectedFrame.origin.x = self.item1.frame.origin.x;
            selectedColor = self.item1.separator.backgroundColor;
            break;
       
        case FRSegmentTypeNearby:
           selectedFrame = self.item2.separator.frame ;
           selectedFrame.origin.x = self.item2.frame.origin.x;

            selectedColor = self.item2.separator.backgroundColor;
            break;
        case FRSegmentTypeFriends:
            selectedFrame = self.item3.separator.frame;
            selectedFrame.origin.x = self.item3.frame.origin.x;

            selectedColor = self.item3.separator.backgroundColor;
            break;
        default:
            break;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.selectLine.frame = selectedFrame;
        self.selectLine.backgroundColor = selectedColor;
    }];
    
}


#pragma mark - Lazy Load

- (FRSegmentItem*)item1
{
    if (!_item1)
    {
        _item1 = [FRSegmentItem new];
        _item1.tag = FRSegmentTypeFeatured;
        [_item1 setTitle:@"Featured" forState:UIControlStateNormal];
        [_item1 addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_item1];
        
        [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(self.buttonWidth));
            make.left.equalTo(self).offset(sideOffset);
        }];
        
        self.selectLine.frame = self.item1.separator.frame;
        
    }
    return _item1;
}


- (FRSegmentItem*)item2
{
    if (!_item2)
    {
        _item2 = [FRSegmentItem new];
        _item2.tag = FRSegmentTypeNearby;
        [_item2 addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [_item2 setTitle:@"Nearby" forState:UIControlStateNormal];
        
        [self addSubview:_item2];
        
        [_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(self.buttonWidth));
            make.centerX.equalTo(self);
            
        }];
    }
    return _item2;
}

- (FRSegmentItem*)item3
{
    if (!_item3)
    {
        _item3 = [FRSegmentItem new];
        _item3.tag = FRSegmentTypeFriends;
        [_item3 addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [_item3 setTitle:@"Friends" forState:UIControlStateNormal];


        [self addSubview:_item3];
        
        [_item3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(self.buttonWidth));
            make.right.equalTo(self).offset(-sideOffset);
        }];
    }
    return _item3;
}

@end
