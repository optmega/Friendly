//
//  FRMessagesSegment.m
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagesSegment.h"
#import "FRSegmentItem.h"

@interface FRMessagesSegment ()

@property (nonatomic, strong) FRSegmentItem* item1;
@property (nonatomic, strong) FRSegmentItem* item2;

@property (nonatomic, assign) CGFloat buttonWidth;
@property (nonatomic, strong) UIView* separatorView;

@property (nonatomic, strong) UIView* selectLine;

@end


static CGFloat const sideOffset = 0;

@implementation FRMessagesSegment

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.buttonWidth = ([UIScreen mainScreen].bounds.size.width) / 2;
        
        [self item2];
        [self.item2.separator setBackgroundColor:[UIColor bs_colorWithHexString:kFriendlyBlueColor]];
        self.item2.separator.hidden = YES;
        self.item1.selected = YES;
        [self separatorView];
        self.backgroundColor = [UIColor whiteColor];
        
        
        CGRect rectFrame = CGRectMake(0, 40 - 2.5, [UIScreen mainScreen].bounds.size.width / 2, 2.5);
        self.selectLine = [[UIView alloc]initWithFrame:rectFrame];
        self.selectLine.backgroundColor = self.item1.separator.backgroundColor;
        self.selectLine.layer.cornerRadius = 2;
        [self addSubview:self.selectLine];

        
    }
    return self;
}

- (void)selectedItem:(UIButton*)sender
{
    NSArray* items = @[self.item1, self.item2];
    [items enumerateObjectsUsingBlock:^(FRSegmentItem* obj, NSUInteger idx, BOOL * _Nonnull stop) {
        obj.selected = NO;
    }];
    
    [self.delegate selectedSegmentIndex:sender.tag];
    sender.selected = YES;
    
    
    CGRect selectedFrame = CGRectZero;
    UIColor* selectedColor = [UIColor clearColor];
    
    switch (sender.tag) {
        case 0:
            
            selectedFrame = self.item1.separator.frame;
            selectedFrame.origin.x = self.item1.frame.origin.x;
            selectedColor = self.item1.separator.backgroundColor;
            break;
            
        case 1:
            selectedFrame = self.item2.separator.frame ;
            selectedFrame.origin.x = self.item2.frame.origin.x;
            
            selectedColor = self.item2.separator.backgroundColor;
            break;
       
        default:
            break;
    }
    
    
    BSDispatchBlockToMainQueue(^{
        
        [UIView animateWithDuration:0.5 animations:^{
            self.selectLine.frame = selectedFrame;
            self.selectLine.backgroundColor = selectedColor;
        }];
    });
    
}


#pragma mark - Lazy Load

- (FRSegmentItem*)item1
{
    if (!_item1)
    {
        _item1 = [FRSegmentItem new];
        _item1.tag = FRMessagesSegmentTypeMessages;
        [_item1 setTitle:@"Messages" forState:UIControlStateNormal];
        [_item1 addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:_item1];
        
        [_item1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(self.buttonWidth));
            make.left.equalTo(self).offset(sideOffset);
        }];
    }
    return _item1;
}


- (FRSegmentItem*)item2
{
    if (!_item2)
    {
        _item2 = [FRSegmentItem new];
        _item2.tag = FRMessagesSegmentTypeFriends;
        [_item2 addTarget:self action:@selector(selectedItem:) forControlEvents:UIControlEventTouchUpInside];
        [_item2 setTitle:@"Friends" forState:UIControlStateNormal];
        
        [self addSubview:_item2];
        
        [_item2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(self);
            make.width.equalTo(@(self.buttonWidth));
            make.right.equalTo(self).offset(-sideOffset);
            
        }];
    }
    return _item2;
}

- (UIView*)separatorView
{
    if (!_separatorView)
    {
        _separatorView = [UIView new];
        _separatorView.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self addSubview:_separatorView];
        [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0.5);
            make.left.bottom.right.equalTo(self);
        }];
    }
    return _separatorView;
}

@end
