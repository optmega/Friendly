//
//  FREventFilterSliderCell.h
//  Friendly
//
//  Created by Sergey Borichev on 25.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSBaseTableViewCell.h"
#import "NMRangeSlider.h"

@interface FREventFilterSliderCell : BSBaseTableViewCell

@property (nonatomic, strong) NMRangeSlider* slider;
@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* contentLabel;

@end
