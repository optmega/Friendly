//
//  FRMyProfileUserBioCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileUserBioCellViewModel.h"

@interface FRMyProfileUserBioCellViewModel ()

@property (nonatomic, assign) CGFloat heightCell;


@end

@implementation FRMyProfileUserBioCellViewModel

- (CGFloat)heightCell
{
//    if(!_heightCell)
    {
        _heightCell = [BSEstimateCellHeight estimateHeightWithAttributedText:[self attributedString] sideOffset:30] + 61;
    }
    return _heightCell;
}

- (NSAttributedString*)attributedString
{
    NSMutableAttributedString* attrString = [[NSMutableAttributedString alloc]initWithString:self.content];
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:1.3];
    [attrString addAttribute:NSParagraphStyleAttributeName
                       value:style
                       range:NSMakeRange(0, self.content.length)];
    [attrString addAttribute:NSFontAttributeName value:FONT_SF_DISPLAY_REGULAR(17) range:NSMakeRange(0, self.content.length)];

    return attrString;
}

- (NSString*)content
{
    if (!_content)
    {
        _content = @"";
    }
    return _content;
}
@end
