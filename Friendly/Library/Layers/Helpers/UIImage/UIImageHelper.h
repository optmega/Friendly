//
//  UIImageHelper.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface UIImageHelper : NSObject

+ (UIImage *)image:(UIImage*)image color:(UIColor*)color;

    /** метод вернет ту же картинку которую принял,
     так как мы, на данный момент отказались от фильтров
 
    */
+ (UIImage*)addFilter:(UIImage*)image;

+ (UIImage *)imageByApplyingAlpha:(UIImage*)image alpha:(CGFloat)alpha;

+ (UIImage *)boxblurImageWithBlur:(CGFloat)blur image:(UIImage*)image;

+ (UIImage*) drawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;

+ (UIImage *)image:(UIImage*)image crop:(CGRect)rect;
+ (UIImage *)imageFromColor:(UIColor *)color;

@end
