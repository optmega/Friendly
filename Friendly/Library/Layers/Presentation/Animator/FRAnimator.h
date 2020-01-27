//
//  FRAnimator.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class MASConstraint;


@interface FRAnimator : NSObject

#pragma mark - CATransition

+ (CATransition*)simpleTransitionWithDuration:(CGFloat)duration;
+ (void)addSimpleTransitionToLayer:(CALayer*)layer duration:(CGFloat)duration;


#pragma mark - Constraints

+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key velocity:(CGFloat)velocity;


+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key;
+ (void)animateConstraint:(MASConstraint*)constraint
                newOffset:(CGFloat)offset
                      key:(NSString*)key
                    delay:(CFTimeInterval)delay
             bouncingRate:(NSUInteger)bounce;

+ (void)animateConstraint:(MASConstraint *)constraint
                newOffset:(CGFloat)offset
                      key:(NSString *)key
                    delay:(CFTimeInterval)delay
             bouncingRate:(NSUInteger)bounce
               completion:(BSCodeBlock)completion;

+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key beginTime:(CFTimeInterval)delay;

#pragma mark - Scale

+ (void)animateScaleOnView:(UIView*)view key:(NSString*)key;


#pragma mark - Alpha

+ (void)animateAlphaLinearOnView:(UIView *)view value:(CGFloat)value key:(NSString *)key;
+ (void)animateAlphaLinearOnView:(UIView *)view value:(CGFloat)alpha key:(NSString *)key delay:(CFTimeInterval)delay;


#pragma mark - Rotation

+ (void)rotateView:(UIView *)view onValue:(NSInteger)rotation key:(NSString *)key;

+ (void)removeAllAnimationsForConstraints:(NSArray*)constraints;
+ (void)animationAppearController:(UIViewController*)controller;

@end
