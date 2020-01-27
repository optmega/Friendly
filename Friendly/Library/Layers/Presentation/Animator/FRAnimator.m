//
//  FRAnimator.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRAnimator.h"
#import "MSSPopMasonry.h"

@implementation FRAnimator

+ (CATransition*)simpleTransitionWithDuration:(CGFloat)duration
{
    CATransition *transition = [CATransition animation];
    transition.duration = 0.1f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    return transition;
}

+ (void)addSimpleTransitionToLayer:(CALayer*)layer duration:(CGFloat)duration
{
    [layer addAnimation:[self simpleTransitionWithDuration:duration] forKey:@"SMSimpleTransition"];
}

#pragma mark - POP

+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key beginTime:(CFTimeInterval)delay
{
        POPSpringAnimation *animati = [POPSpringAnimation new];
        animati.property = [POPAnimatableProperty mas_offsetProperty];
        animati.toValue = @(offset);
        animati.beginTime = CACurrentMediaTime() + delay;
        animati.springBounciness = 15;
        animati.springSpeed = 3;
        [constraint pop_addAnimation:animati forKey:key];
}

+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key
{
    [self animateConstraint:constraint newOffset:offset key:key delay:0.1 bouncingRate:0];
}


+ (void)animateConstraint:(MASConstraint*)constraint newOffset:(CGFloat)offset key:(NSString*)key velocity:(CGFloat)velocity
{
    POPSpringAnimation *animation = [constraint pop_animationForKey:key];
    if (!animation)
    {
        animation = [POPSpringAnimation new];
        animation.property = [POPAnimatableProperty mas_offsetProperty];
    }
    animation.toValue = @(offset);
    animation.springBounciness = 0;
    animation.velocity = @(velocity);
    animation.beginTime = CACurrentMediaTime();
    [animation setCompletionBlock:^(POPAnimation* animation, BOOL isFinished) {
        
    }];
    [constraint pop_addAnimation:animation forKey:key];

}

+ (void)animateConstraint:(MASConstraint *)constraint newOffset:(CGFloat)offset key:(NSString *)key delay:(CFTimeInterval)delay bouncingRate:(NSUInteger)bounce completion:(BSCodeBlock)completion
{
    POPSpringAnimation *animation = [constraint pop_animationForKey:key];
    if (!animation)
    {
        animation = [POPSpringAnimation new];
        animation.property = [POPAnimatableProperty mas_offsetProperty];
    }
    animation.toValue = @(offset);
    animation.springBounciness = bounce;
    animation.beginTime = CACurrentMediaTime() + delay;
    [animation setCompletionBlock:^(POPAnimation* animation, BOOL isFinished) {
        if (isFinished && completion)
        {
            completion();
        }
    }];
    [constraint pop_addAnimation:animation forKey:key];
}

+ (void)animateConstraint:(MASConstraint*)constraint
                newOffset:(CGFloat)offset
                      key:(NSString*)key
                    delay:(CFTimeInterval)delay
             bouncingRate:(NSUInteger)bounce
{
    [self animateConstraint:constraint newOffset:offset key:key delay:delay bouncingRate:bounce completion:nil];
}

+ (void)animateScaleOnView:(UIView*)view key:(NSString*)key
{
    POPSpringAnimation *scaleAnimation = [view pop_animationForKey:key];
    if (!scaleAnimation)
    {
        scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    }
    
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(2.5, 2.5)];
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
    scaleAnimation.springBounciness = 0;
    [view.layer pop_addAnimation:scaleAnimation forKey:key];
}

+ (void)animateAlphaLinearOnView:(UIView *)view value:(CGFloat)value key:(NSString *)key
{
    [self animateAlphaLinearOnView:view value:value key:key delay:0];
}

+ (void)animateAlphaLinearOnView:(UIView *)view value:(CGFloat)alpha key:(NSString *)key delay:(CFTimeInterval)delay
{
    POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewAlpha];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    anim.toValue = @(alpha);
    anim.beginTime = CACurrentMediaTime() + delay;
    [view pop_addAnimation:anim forKey:key];
}

+ (void)rotateView:(UIView *)view onValue:(NSInteger)rotation key:(NSString *)key
{
    POPSpringAnimation *rotate = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
    CGFloat rotationDegree = (((2 * M_PI) / 360) * rotation);
    rotate.toValue = @(rotationDegree);
    rotate.springBounciness = 13.00f;
    rotate.springSpeed = 2.0f;
    [view.layer pop_addAnimation:rotate forKey:key];
}

+ (void)removeAllAnimationsForConstraints:(NSArray*)constraints
{
    for (MASConstraint* constraint in constraints)
    {
        [constraint pop_removeAllAnimations];
    }
}

+ (void)animationAppearController:(UIViewController*)controller
{
    CALayer *layer = controller.view.layer;
    [layer pop_removeAllAnimations];
    POPSpringAnimation *xAnim = [layer pop_animationForKey:@"position"];
    if (!xAnim)
    {
        xAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    }
    
    POPSpringAnimation *sizeAnim = [layer pop_animationForKey:@"size"];
    if (!sizeAnim)
    {
        sizeAnim = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerSize];
    }
    
    xAnim.fromValue = @(320);
    xAnim.springBounciness = 16;
    xAnim.springSpeed = 10;
    sizeAnim.fromValue = [NSValue valueWithCGSize:CGSizeMake(0, 0)];

    [layer pop_addAnimation:xAnim forKey:@"position"];
    [layer pop_addAnimation:sizeAnim forKey:@"size"];
    
}



@end
