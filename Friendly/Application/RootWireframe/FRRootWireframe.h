//
//  FRRootWireframe.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@interface FRRootWireframe : NSObject

@property (nonatomic, weak) UIWindow* window;

- (void)showRootViewController:(UIViewController *)viewController inWindow:(UIWindow *)window;
- (void)showIntroController:(UIWindow*)window;
- (void)showHomeController:(UIWindow*)window;
@end
