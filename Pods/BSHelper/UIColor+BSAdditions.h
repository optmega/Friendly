//
//  UIColor+BSAdditions.h
//
//  Created by Sergey Borichev on 30.11.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//
@interface UIColor (BSAdditions)

+ (UIColor*)bs_colorWithHexString:(NSString *)stringToConvert;
+ (UIColor*)bs_randomColor;

- (NSString*)bs_hexString;

@end
