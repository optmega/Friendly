//
//  FRIntroPulseVeiw.m
//  Friendly
//
//  Created by Sergey Borichev on 27.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRIntroPulseVeiw.h"

@implementation FRIntroPulseVeiw

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"bounds"];
    boundsAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 80, 80)];
    boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 170, 170)];
    boundsAnim.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseOut];

    
    CABasicAnimation *cornerRadiusAnim = [CABasicAnimation animationWithKeyPath:@"cornerRadius"];
    cornerRadiusAnim.timingFunction = [CAMediaTimingFunction     functionWithName:kCAMediaTimingFunctionEaseOut];
    cornerRadiusAnim.toValue = [NSNumber numberWithFloat:85];
    cornerRadiusAnim.fromValue = [NSNumber numberWithFloat:40];
    
    CABasicAnimation* opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnim.toValue = @0.;
    opacityAnim.fromValue = @0.85;
   
    
    CAAnimationGroup *anims = [CAAnimationGroup animation];
    anims.animations = [NSArray arrayWithObjects: cornerRadiusAnim, boundsAnim, opacityAnim, nil];
    anims.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    anims.removedOnCompletion = NO;
    anims.duration = 2.0f;
    anims.fillMode  = kCAFillModeForwards;
    anims.repeatCount = INFINITY;
    [self.layer addAnimation:anims forKey:@"DD"];
    
}



@end
