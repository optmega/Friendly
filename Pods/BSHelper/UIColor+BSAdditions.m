//
//  UIColor+BSAdditions.m
//
//  Created by Sergey Borichev on 30.11.15.
//  Copyright © 2015 TecSynt. All rights reserved.
//

#import "UIColor+BSAdditions.h"

@implementation UIColor (BSAdditions)

+ (UIColor *)bs_colorWithHexString:(NSString *)stringToConvert
{
    if ([stringToConvert rangeOfString:@"#"].location != NSNotFound)
    {
        stringToConvert = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""];
    }
	NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
	unsigned hexNum;
	if (![scanner scanHexInt:&hexNum]) return nil;
    int r = (hexNum >> 16) & 0xFF;
	int g = (hexNum >> 8) & 0xFF;
	int b = (hexNum) & 0xFF;
	return [UIColor colorWithRed:r / 255.0f
						   green:g / 255.0f
							blue:b / 255.0f
						   alpha:1.0f];
}

- (NSString *)bs_hexString
{
    const CGFloat *components = CGColorGetComponents(self.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

+ (UIColor*)bs_randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

@end
