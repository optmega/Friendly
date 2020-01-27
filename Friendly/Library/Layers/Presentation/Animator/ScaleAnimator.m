//
//  ScaleAnimator.m
//  Friendly
//
//  Created by vaskov on 06.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "ScaleAnimator.h"

@implementation ScaleAnimator

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext
{
    return 0.15f;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    UIViewController* toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController* fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    [[transitionContext containerView] addSubview:toViewController.view];
    
    
    toViewController.view.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    [toViewController.view addSubview:fromViewController.view];
    //fromViewController.view.transform = CGAffineTransformMakeScale(0.4, 0.4);
    
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromViewController.view.transform = CGAffineTransformMakeScale(0.6f, 0.6f);
    } completion:^(BOOL finished) {
        //fromViewController.view.transform = CGAffineTransformIdentity;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        
    }];
}

@end
