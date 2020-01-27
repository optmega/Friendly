//
//  FRBaseVC.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseVC.h"

@interface FRBaseVC ()

@end

@implementation FRBaseVC

- (void)viewDidLoad
{
    [super viewDidLoad];
        
    self.overleyNavBar.hidden = true;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [UIView setAnimationsEnabled:true];
    [self setNeedsStatusBarAppearanceUpdate];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSLog(@"init %@", self);
    }
    return self;
}


- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)changePositionY:(CGFloat)y
{
//    self.statusBarBackgraundView.alpha = y / 40;
}

- (UIView*)statusBarBackgraundView
{
    if (!_statusBarBackgraundView)
    {
        _statusBarBackgraundView = [UIView new];
//        _statusBarBackgraundView.backgroundColor = [[UIColor bs_colorWithHexString:@"#765BF8"] colorWithAlphaComponent:0.6];
        _statusBarBackgraundView.alpha = 0;
        [self.view addSubview:_statusBarBackgraundView];
        
        [_statusBarBackgraundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@20);
        }];
    }
    [self.view bringSubviewToFront:_statusBarBackgraundView];
    return _statusBarBackgraundView;
}

- (UIImageView*)overleyNavBar
{
    if (!_overleyNavBar)
    {
        _overleyNavBar = [UIImageView new];
        _overleyNavBar.hidden = true;
        _overleyNavBar.image = [UIImage imageNamed:@"Offline Copy"];
        _overleyNavBar.layer.zPosition += 1;
        [self.view addSubview:_overleyNavBar];
        [_overleyNavBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.height.equalTo(@64);
        }];
    }
    return _overleyNavBar;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    
    return UIStatusBarStyleDefault;
}

@end

BOOL setStatusBarColor(UIColor *color)
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
        
        [statusBar performSelector:setForegroundColor_sel withObject:color];
        
        return YES;
    } else {
        return NO;
    }
}
