//
//  WhiteHeaderVC.h
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

//#import "ViewController.h"

@interface WhiteHeaderVC : UIViewController

@property (nonatomic, strong) UIToolbar* toolbar;
@property (nonatomic, strong) UIButton* closeButton;
@property (nonatomic, strong) UILabel* titleLabel;
-(void) backHome:(UIButton*)sender;
@end
