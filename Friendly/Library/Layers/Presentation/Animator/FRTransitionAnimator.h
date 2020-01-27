//
//  FRShowEventsParentVC.h
//  Friendly
//
//  Created by Sergey Borichev on 10.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface FRTransitionAnimator : NSObject

- (void)presentViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController withBlock:(void (^)(void))completion;
- (void)presentViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController;
- (void)dismissViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController;

- (void)scaleViewController:(UIViewController *)toViewController from:(UIViewController*)fromViewController withBlock:(void (^)(void))completion;
@end
