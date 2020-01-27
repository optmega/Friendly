//
//  FREventFilterDistanceCell.m
//  Friendly
//
//  Created by Sergey Borichev on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventFilterDistanceCell.h"

@interface FREventFilterDistanceCell ()

@property (nonatomic, strong) FREventFilterDistanceCellViewModel* model;

@end

@implementation FREventFilterDistanceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.slider.lowerHandleHidden = YES;
        self.slider.minimumValue = 1;
        self.slider.maximumValue = 60;
        [self.slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        self.titleLabel.text =  FRLocalizedString(@"Distance", nil) ;
        
    }
    return self;
}

- (void)updateWithModel:(FREventFilterDistanceCellViewModel*)model
{
    self.model = model;
    self.slider.upperValue = model.radius;
    self.contentLabel.text = [NSString stringWithFormat:@"%ld km", (long)model.radius];
}


- (void)sliderAction:(NMRangeSlider*)sender
{
    self.contentLabel.text = [NSString stringWithFormat:@"%ld km", (long)sender.upperValue];
    self.model.radius = (long)sender.upperValue;
}


@end
