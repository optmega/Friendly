//
//  FRCreateEventOpenSlotsInputVeiw.m
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventOpenSlotsInputVeiw.h"
#import "FRStyleKit.h"
#import "NMRangeSlider.h"


@interface FRCreateEventOpenSlotsInputVeiw ()

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* rangeLabel;
@property (nonatomic, strong) NMRangeSlider* slider;

@property (nonatomic, assign) NSInteger min;
@property (nonatomic, assign) NSInteger max;
@end


@implementation FRCreateEventOpenSlotsInputVeiw

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self titleLabel];
        [self slider];
        [self rangeLabel];
        [self sliderAction:self.slider];
        [self.cancelButton addTarget:self action:@selector(doneSelected:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)updateUpperValue:(NSInteger)upperValue
{
    self.slider.upperValue = upperValue;
    [self sliderAction:self.slider];
}

- (void)sliderAction:(NMRangeSlider*)sender
{
    self.rangeLabel.text = [NSString stringWithFormat:@"%ld",(long)sender.upperValue];
}

- (void)doneSelected:(UIButton*)sender
{
    [self.delegate slotsUpdate:(NSInteger)self.slider.upperValue];
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
        _titleLabel.text = FRLocalizedString(@"Open slots", nil);
        [self.headerView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.headerView.mas_centerX).offset(-20);
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
        _rangeLabel.text = @"1";
        _rangeLabel.font = FONT_SF_DISPLAY_MEDIUM(19);
        _rangeLabel.textColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [self.headerView addSubview:_rangeLabel];
        
        [_rangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.titleLabel.mas_left).offset(-3);
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
        _slider.minimumValue = 1;
        _slider.maximumValue = 20;
        _slider.lowerHandleHidden = YES;
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_slider];
        
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headerView.mas_bottom).offset(20);
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.height.equalTo(@50);
        }];
    }
    return _slider;
}



@end
