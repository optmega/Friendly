//
//  FRInputViewAges.m
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRInputViewAges.h"
#import "NMRangeSlider.h"
#import "FRStyleKit.h"
#import "BSHudHelper.h"

@interface FRInputViewAges()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* rangeLabel;
@property (nonatomic, strong) NMRangeSlider* slider;

@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;

@end

 
@implementation FRInputViewAges

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
       
        [self headerView];
        [self titleLabel];
        [self rangeLabel];
        [self slider];
       
        _min = 18;
        _max = 34;
        
        self.slider.upperValue = 16;

        [self.cancelButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)setAgeMin:(CGFloat)min max:(CGFloat)max
{
    self.slider.lowerValue = min - 18;
    self.slider.upperValue = max - 18;
    [self sliderAction:self.slider];
}

- (void)sliderAction:(NMRangeSlider*)sender
{
    self.min = (NSInteger)sender.lowerValue + 18;
    self.max = (NSInteger)sender.upperValue + 18;
    self.rangeLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)_min, (long)_max];
}

- (void)doneAction:(UIButton*)sender
{
    if (self.max - self.min  < 5)
    {
        [self.delegate selectedWrongRange];
        return;
    }
    
    [self.delegate updateAgesMin:_min max:_max];
}

- (void)closeSelected
{
    [self.delegate closeSelected];
}

#pragma mark - Lazy Load
 
- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"#263345"];
        _titleLabel.text = FRLocalizedString(@"Ages", nil);
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.headerView.mas_centerX).offset(-1);
            make.centerY.equalTo(self.headerView);
        }];
    }
    return _titleLabel;
}

- (UILabel*)rangeLabel
{
    if (!_rangeLabel)
    {
        _rangeLabel = [UILabel new];
        _rangeLabel.text = @"18-34";
        _rangeLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _rangeLabel.textColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.headerView addSubview:_rangeLabel];
        
        [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_centerX).offset(1);
            make.centerY.equalTo(self.headerView);
        }];
    }
    return _rangeLabel;
}


- (NMRangeSlider*)slider
{
    if (!_slider)
    {
        _slider = [NMRangeSlider new];
        _slider.maximumValue = 32;

        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self).offset(5);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.height.equalTo(@50);
        }];
    }
    return _slider;
}

- (void)dealloc
{
    
}


@end
