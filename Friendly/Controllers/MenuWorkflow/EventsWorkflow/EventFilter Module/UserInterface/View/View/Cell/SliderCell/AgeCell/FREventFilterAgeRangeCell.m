//
//  FREventFilterAgeRangeCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterAgeRangeCell.h"

@interface FREventFilterAgeRangeCell ()

@property (nonatomic, strong) FREventFilterAgeRangeCellViewModel* model;

@end


static NSInteger const kMinAge = 18;

@implementation FREventFilterAgeRangeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.slider.minimumValue = 0;
        self.slider.maximumValue = 50 - kMinAge;
        [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        self.titleLabel.text =  FRLocalizedString(@"Age range", nil) ;
    }
    return self;
}

- (void)updateWithModel:(FREventFilterAgeRangeCellViewModel*)model
{
    self.model = model;
    self.slider.upperValue = model.maxAge - kMinAge;
    self.slider.lowerValue = model.minAge - kMinAge;
    self.contentLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)model.minAge, model.maxAge];
}


- (void)sliderAction:(NMRangeSlider*)sender
{
    NSInteger max = sender.upperValue + kMinAge;
    NSInteger min = sender.lowerValue + kMinAge;
    self.model.maxAge = max;
    self.model.minAge = min;
    self.contentLabel.text = [NSString stringWithFormat:@"%ld-%ld", (long)min, (long)max];
}


@end
