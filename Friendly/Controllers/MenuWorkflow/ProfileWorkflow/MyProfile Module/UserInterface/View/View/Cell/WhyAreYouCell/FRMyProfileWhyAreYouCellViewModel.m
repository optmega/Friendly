//
//  FRMyProfileWhyAreYouCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileWhyAreYouCellViewModel.h"

@interface FRMyProfileWhyAreYouCellViewModel ()

@property (nonatomic, assign) CGFloat cellHeight;

@end

@implementation FRMyProfileWhyAreYouCellViewModel

- (CGFloat)cellHeight
{
//    if (!_cellHeight)
    {
        _cellHeight = [BSEstimateCellHeight estimateHeightWithAttributedText:[self attributedString] sideOffset:30] + 76;
    }
    
    return _cellHeight;
}


- (NSAttributedString*)attributedString
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:[NSObject bs_safeString:self.subtitle]];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:1.3];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.subtitle.length)];
    [attrString addAttribute:NSFontAttributeName value:FONT_SF_DISPLAY_REGULAR(17) range:NSMakeRange(0, self.subtitle.length)];
    
    return attrString;
}


@end



