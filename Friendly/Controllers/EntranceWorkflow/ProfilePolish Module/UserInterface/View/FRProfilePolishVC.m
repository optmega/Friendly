//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishVC.h"
#import "FRProfilePolishController.h"
#import "FRProfilePolishDataSource.h"
#import "FRProfilePolishContentVIew.h"
#import "FRFooterQuestionairView.h"
#import "UIImageView+WebCache.h"
#import "FRUserManager.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "DAKeyboardControl.h"
#import "FRHeaderQuestionairView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"

@interface FRProfilePolishVC ()

@property (nonatomic, strong) FRProfilePolishController* controller;
@property (nonatomic, strong) FRProfilePolishContentVIew* contentView;
@property (nonatomic, strong) UIButton* backButton;

@end

static CGFloat const kAnimationDuration = 0.7;
static CGFloat const kMinOpasity = 0.15;

@implementation FRProfilePolishVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentView = [FRProfilePolishContentVIew new];
        self.controller = [[FRProfilePolishController alloc] initWithTableView:self.contentView.tableView];
        self.controller.scrollDelegate = self;
        [self backButton];
    }
    return self;
}


- (void)loadView
{
    self.view = self.contentView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setViewAlpha:kMinOpasity];
    [self attachKeyboardHelper];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:kAnimationDuration animations:^{
     
        [self setViewAlpha:1];
    }];
    
    [APP_DELEGATE sendToGAScreen:@"ProfilePolish"];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self detachKeyboardHelper];
}

- (void)showHiddenAnimationWithComplete:(void(^)())complete
{
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self setViewAlpha:kMinOpasity];
           } completion:^(BOOL finished) {
       if (complete)
           complete();
    }];
}

- (void)setViewAlpha:(CGFloat)alpha
{
    self.contentView.tableView.alpha = alpha;

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self.contentView.tableView addSubview:self.overleyNavBar];

    self.contentView.layer.cornerRadius = 8;
    self.contentView.footerView.continueButton.enabled = true;
    @weakify(self);
    
    self.contentView.footerView.backgroundColor = [UIColor whiteColor];
    [[self.contentView.footerView.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler finishSelected];
    }];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.controller hideKeyboard];
        [self.eventHandler backSelected];
    }];
    self.overleyNavBar.layer.zPosition = 1;

    self.overleyNavBar.hidden = self.isHideOverley;
    

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

- (void)attachKeyboardHelper{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillAppear:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];
}

- (void)detachKeyboardHelper{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)keyboardWillAppear:(NSNotification *)notification{
    NSDictionary* userInfo = [notification userInfo];
    
    CGRect keyboardEndFrame;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
    
    // Animate up or down
    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
    
  
    
    
    [self.contentView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-keyboardFrame.size.height);
    }];
    
    
 
//    [self.contentView layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [self.contentView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
    
//    [self.contentView layoutIfNeeded];
}

#pragma mark - User Interface

- (void)updateDataSource:(FRProfilePolishDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


- (void)changePositionY:(CGFloat)y
{
    [super changePositionY:y];
//    CGRect frame = self.backButton.frame;
//    frame.origin.y = 30 + y;
//    self.backButton.frame = frame;
}

#pragma mark - FRTableController Delegate

#pragma mark - LazyLoad

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 30, 30)];
        _backButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _backButton.layer.cornerRadius = 15;
        _backButton.layer.zPosition += 10;
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        [_backButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
        UIImage* image = [UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[[UIColor whiteColor] colorWithAlphaComponent:0.8]];
        
        [_backButton setImage:image forState:UIControlStateHighlighted];
        _backButton.tintColor = [UIColor whiteColor];
        [self.view addSubview:_backButton];
    }
    
    return _backButton;
}


@end
