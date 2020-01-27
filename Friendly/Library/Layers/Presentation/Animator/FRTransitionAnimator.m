//
//  FRShowEventsParentVC.m
//  Friendly
//
//  Created by Sergey Borichev on 10.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRTransitionAnimator.h"
#import "FREventsWireframe.h"
#import "FREventsVC.h"
#import "Animator.h"
#import "ScaleAnimator.h"


@interface PrivateTransitionContext : NSObject <UIViewControllerContextTransitioning>

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight; /// Designated initializer.
@property (nonatomic, copy) void (^completionBlock)(BOOL didComplete); /// A block of code we can set to execute after having received the completeTransition: message.
@property (nonatomic, assign, getter=isAnimated) BOOL animated; /// Private setter for the animated property.
@property (nonatomic, assign, getter=isInteractive) BOOL interactive; /// Private setter for the interactive property.

@end


@interface FRTransitionAnimator ()

@property (nonatomic, strong) FREventsVC* eventsChiledVC;

@end

@implementation FRTransitionAnimator

- (void)presentViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController withBlock:(void (^)(void))completion {
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
    UIView* toView = toViewController.view;
    toView.backgroundColor = [UIColor clearColor];
    Animator *animator = [[Animator alloc] init];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:YES];
    
    transitionContext.animated = YES;
    transitionContext.interactive = YES;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        //        [fromViewController.view removeFromSuperview];
        
        fromViewController.view.alpha = 1;
        [fromViewController presentViewController:toViewController animated:NO completion:^{
            completion();
        }];
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];
}
- (void)presentViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController
{
    
    [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];
    UIView* toView = toViewController.view;
    toView.backgroundColor = [UIColor clearColor];
    Animator *animator = [[Animator alloc] init];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:YES];
    
    transitionContext.animated = YES;
    transitionContext.interactive = YES;
    transitionContext.completionBlock = ^(BOOL didComplete) {
//        [fromViewController.view removeFromSuperview];

        fromViewController.view.alpha = 1;
        
        UIViewController* temp = fromViewController.presentingViewController ? fromViewController.presentingViewController : fromViewController;
        
        [temp presentViewController:toViewController animated:NO completion:^{
        
        }];

        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];
}

- (void)dismissViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController
{
    UIView* toView = toViewController.view;
    toView.backgroundColor = [UIColor clearColor];
    Animator *animator = [[Animator alloc] init];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:YES];
    
    @weakify(fromViewController);
    transitionContext.animated = YES;
    transitionContext.interactive = YES;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        @strongify(fromViewController);
        fromViewController.view.alpha = 0;
        [fromViewController dismissViewControllerAnimated:NO completion:nil];
        
        BSDispatchBlockAfter(0.5, ^{
            
            toViewController.view.alpha = 1;
            
            [UIApplication sharedApplication].keyWindow.backgroundColor = [UIColor blackColor];

        });
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];

}

- (void)scaleViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController withBlock:(void (^)(void))completion
{
    UIView* toView = toViewController.view;
    toView.backgroundColor = [UIColor clearColor];
    ScaleAnimator *animator = [[ScaleAnimator alloc] init];
    PrivateTransitionContext *transitionContext = [[PrivateTransitionContext alloc] initWithFromViewController:fromViewController toViewController:toViewController goingRight:YES];
    
    transitionContext.animated = YES;
    transitionContext.interactive = YES;
    transitionContext.completionBlock = ^(BOOL didComplete) {
        completion();
        
        if ([animator respondsToSelector:@selector (animationEnded:)]) {
            [animator animationEnded:didComplete];
        }
    };
    [animator animateTransition:transitionContext];
}


- (void)dealloc
{
    
}
@end


#pragma mark - Private Transitioning Classes

@interface PrivateTransitionContext ()
@property (nonatomic, strong) NSDictionary *privateViewControllers;
@property (nonatomic, assign) CGRect privateDisappearingFromRect;
@property (nonatomic, assign) CGRect privateAppearingFromRect;
@property (nonatomic, assign) CGRect privateDisappearingToRect;
@property (nonatomic, assign) CGRect privateAppearingToRect;
@property (nonatomic, weak) UIView *containerView;
@property (nonatomic, assign) UIModalPresentationStyle presentationStyle;
@end

@implementation PrivateTransitionContext

- (instancetype)initWithFromViewController:(UIViewController *)fromViewController toViewController:(UIViewController *)toViewController goingRight:(BOOL)goingRight {
//    NSAssert ([fromViewController isViewLoaded] && fromViewController.view.superview, @"The fromViewController view must reside in the container view upon initializing the transition context.");
    
    if ((self = [super init])) {
        self.presentationStyle = UIModalPresentationCustom;
        self.containerView = fromViewController.view.superview;
        self.privateViewControllers = @{
                                        UITransitionContextFromViewControllerKey:fromViewController,
                                        UITransitionContextToViewControllerKey:toViewController,
                                        };
        
        // Set the view frame properties which make sense in our specialized ContainerViewController context. Views appear from and disappear to the sides, corresponding to where the icon buttons are positioned. So tapping a button to the right of the currently selected, makes the view disappear to the left and the new view appear from the right. The animator object can choose to use this to determine whether the transition should be going left to right, or right to left, for example.
        CGFloat travelDistance = (goingRight ? -self.containerView.bounds.size.width : self.containerView.bounds.size.width);
        self.privateDisappearingFromRect = self.privateAppearingToRect = self.containerView.bounds;
        self.privateDisappearingToRect = CGRectOffset (self.containerView.bounds, travelDistance, 0);
        self.privateAppearingFromRect = CGRectOffset (self.containerView.bounds, -travelDistance, 0);
    }
    
    return self;
}

- (CGRect)initialFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingFromRect;
    } else {
        return self.privateAppearingFromRect;
    }
}

- (CGRect)finalFrameForViewController:(UIViewController *)viewController {
    if (viewController == [self viewControllerForKey:UITransitionContextFromViewControllerKey]) {
        return self.privateDisappearingToRect;
    } else {
        return self.privateAppearingToRect;
    }
}

- (UIViewController *)viewControllerForKey:(NSString *)key {
    return self.privateViewControllers[key];
}

- (void)completeTransition:(BOOL)didComplete {
    if (self.completionBlock) {
        self.completionBlock (didComplete);
    }
}

- (BOOL)transitionWasCancelled { return NO; } // Our non-interactive transition can't be cancelled (it could be interrupted, though)

// Supress warnings by implementing empty interaction methods for the remainder of the protocol:

- (void)updateInteractiveTransition:(CGFloat)percentComplete {}
- (void)finishInteractiveTransition {}
- (void)cancelInteractiveTransition {}

- (void)dealloc {
    
}
@end