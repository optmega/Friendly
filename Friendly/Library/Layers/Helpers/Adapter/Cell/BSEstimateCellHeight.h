//
//  BSEstimateCellHeight.h
//  Friendly
//
//  Created by Sergey Borichev on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@interface BSEstimateCellHeight : NSObject

+ (CGFloat)estimateHeightWithText:(NSString*)text font:(UIFont*)font sideOffset:(CGFloat)sideOffset;
+ (CGFloat)estimateHeightWithAttributedText:(NSAttributedString*)attributedText sideOffset:(CGFloat)sideOffset;

@end
