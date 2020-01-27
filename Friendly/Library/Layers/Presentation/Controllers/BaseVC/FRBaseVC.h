//
//  FRBaseVC.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@interface FRBaseVC : UIViewController <BSTableControllerDelegate>

@property (nonatomic, strong) UIView* statusBarBackgraundView;
@property (nonatomic, strong) UIImageView* overleyNavBar;

@property (nonatomic, assign) BOOL isHideOverley;
@end


BOOL setStatusBarColor(UIColor *color);