//
//  FRVCWithOpacity.m
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"
#import "FRAnimator.h"
#import "FRBaseVC.h"

@interface FRVCWithOpacity()

@property (nonatomic, strong) MASConstraint* heightConstraint;

@end

@implementation FRVCWithOpacity

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self footerView];
    UITapGestureRecognizer* tapGest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeVC)];
    [self.emptyFieldView addGestureRecognizer:tapGest];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor clearColor];
    [UIView animateWithDuration:0.3 animations:^{
        
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [FRAnimator animateConstraint:self.bottom newOffset:0 key:@"bottom" delay:0 bouncingRate:0];
        
    } completion:^(BOOL finished)
     {
         

     }];

}

- (void)closeVC
{
    [FRAnimator animateConstraint:self.bottom newOffset:self.heightFooter key:@"bottom"];
    
    [UIView animateWithDuration:0.3 animations:^{
       self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    } completion:^(BOOL finished)
     {
         [self dismissViewControllerAnimated:YES completion:nil];
     }];
    
}


#pragma mark - Lazy Load

- (UIView*)emptyFieldView
{
    if (!_emptyFieldView)
    {
        _emptyFieldView = [UIView new];
        _emptyFieldView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_emptyFieldView];
        
        [_emptyFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.view);
            make.bottom.equalTo(self.footerView.mas_top);
        }];
    }
    return _emptyFieldView;
}

- (UIView*)footerView
{
    if (!_footerView)
    {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_footerView];
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            
           self.heightConstraint = make.height.equalTo(@(self.heightFooter));
            make.left.right.equalTo(self.view);
           self.bottom =  make.bottom.equalTo(self.view).offset(self.heightFooter);
        }];
    }
    return _footerView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

@end
