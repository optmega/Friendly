//
//  FRProfileTextFieldCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRProfileTextViewCellViewModel.h"

@interface FRProfileTextViewCellViewModel()

@property (nonatomic, assign) CGFloat cellHeight;


@end

@implementation FRProfileTextViewCellViewModel

- (CGFloat)cellHeight
{
//    if (!_cellHeight)
//    {
        NSString* text = self.dataString.length ? self.dataString : self.subtitle;
    _cellHeight = [BSEstimateCellHeight estimateHeightWithText:text font:FONT_SF_DISPLAY_REGULAR(17) sideOffset:40] + 31 + 45; // 37.5 + 25;
//    }
    
    return _cellHeight;
}

- (NSInteger)maxCountCharacter
{
    if (!_maxCountCharacter)
    {
        _maxCountCharacter = 200;
    }
    return _maxCountCharacter;
}

@end
