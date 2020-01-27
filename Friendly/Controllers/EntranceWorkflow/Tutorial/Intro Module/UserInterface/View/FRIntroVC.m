//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroVC.h"
#import "FRIntroController.h"
#import "FRIntroDataSource.h"
#import "FRIntroContentView.h"
#import "EAIntroPage.h"
#import "FRPageView.h"
#import "FRIntroMessageBaseView.h"
#import "FRAnimator.h"
#import "FRIntroPulseVeiw.h"


@interface FRIntroVC () <FRIntroContentViewDelegate>

@property (nonatomic, strong) FRIntroController* controller;
@property (nonatomic, strong) FRIntroContentView* contentView;

@property (nonatomic, assign) CGFloat screenWidth;


@property (nonatomic, strong) FRIntroPulseVeiw* pulseView;

@property (nonatomic, strong) UIImageView* userImage;
@property (nonatomic, assign) CGFloat userPhotoWidth;
@property (nonatomic, assign) CGFloat userPhotoTopOffset;

@property (nonatomic, strong) MASConstraint* userImageHeightConstraint;
@property (nonatomic, assign) MASConstraint* userImageTopConstraint;
@property (nonatomic, assign) MASConstraint* userImageLeftOffsetConstraint;


@property (nonatomic, assign) MASConstraint* leftMessageViewTopConstraint;
@property (nonatomic, assign) MASConstraint* centerMessageViewTopConstraint;
@property (nonatomic, assign) MASConstraint* rightMessageViewTopConstraint;


@property (nonatomic, strong) FRIntroMessageBaseView* leftMessageView;
@property (nonatomic, strong) FRIntroMessageBaseView* centerMessageView;
@property (nonatomic, strong) FRIntroMessageBaseView* rightMessageView;


@property (nonatomic, strong) UIImageView* firstBigMessageView;
@property (nonatomic, strong) UIImageView* secondBigMessageView;

@property (nonatomic, strong) MASConstraint* firstBigMessageViewTopConstraint;
@property (nonatomic, strong) MASConstraint* secondBigMessageViewTopConstraint;


@property (nonatomic, strong) UIImageView* countMessageView;
@property (nonatomic, strong) MASConstraint* countMessageViewConstraint;

@property (nonatomic, assign) CGFloat messageWidth;


@property (nonatomic, assign) CGFloat leftMessageY;
@property (nonatomic, assign) CGFloat centerMessageY;
@property (nonatomic, assign) CGFloat rightMessateY;

@property (nonatomic, assign) CGFloat lastPositionX;


@property (nonatomic, strong) UIImageView* userImageFirstFourthPageImage;
@property (nonatomic, strong) UIImageView* messageFirstFourthPageImage;


@property (nonatomic, strong) UIImageView* userImageSecondFourthPageImage;
@property (nonatomic, strong) UIImageView* messageSecondFourthPageImage;


@property (nonatomic, strong) MASConstraint* heightFirstUserImageFoutthConstraint;
@property (nonatomic, strong) MASConstraint* heightSecondUserImageFoutthConstraint;

@property (nonatomic, strong) MASConstraint* rightFirstMessageFoutthConstraint;
@property (nonatomic, strong) MASConstraint* leftSecondMessageFoutthConstraint;

@property (nonatomic, assign) BOOL isIphone4;

@end


#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width

@implementation FRIntroVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentView = [FRIntroContentView new];
        self.contentView.delegate = self;
        self.isIphone4 = !IS_IPHONE_5_OR_HIGHER;
 
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

- (FRIntroPulseVeiw*)pulseView
{
    if (!_pulseView)
    {
        _pulseView = [FRIntroPulseVeiw new];
        _pulseView.backgroundColor = [[UIColor bs_colorWithHexString:kPurpleColor] colorWithAlphaComponent:0.8];
        [self.view addSubview:_pulseView];
        
        [_pulseView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.height.width.equalTo(@80);
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.userImage);
        }];
    }
    return _pulseView;
}

- (void)loadView
{
    self.view = self.contentView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [[self.contentView.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler loginSelected];
        [self.contentView closePrivacy];
    }];
    
   
    self.messageWidth = [UIScreen mainScreen].bounds.size.width / 3.1;
    self.screenWidth = [UIScreen mainScreen].bounds.size.width;
    self.userPhotoWidth = self.screenWidth / 4.4;
    self.userPhotoTopOffset = [UIScreen mainScreen].bounds.size.height / 3.92;
    
    self.contentView.page2.customPageView.alpha = 0;
    self.contentView.page2.customPageView.titleLabel.alpha = 0;
    self.contentView.page2.customPageView.subtitleLabel.alpha = 0;
    self.contentView.page3.customPageView.titleLabel.alpha = 0;
    self.contentView.page3.customPageView.subtitleLabel.alpha = 0;
    self.contentView.page3.customPageView.alpha = 0;
    self.contentView.page4.customPageView.contentView.alpha = 0;
    self.contentView.page4.customPageView.titleLabel.alpha = 0;
    self.contentView.page4.customPageView.subtitleLabel.alpha = 0;
    
    
    [self pulseView];
    
    [self userImage];
    [self leftMessageView];
    [self rightMessageView];
    [self centerMessageView];
    
    [self userImageFirstFourthPageImage];
    [self messageFirstFourthPageImage];
    
    [self userImageSecondFourthPageImage];
    [self messageSecondFourthPageImage];
    
    [self countMessageView];
    self.firstBigMessageView.alpha = 0;
    self.secondBigMessageView.alpha = 0;
    self.countMessageView.alpha = 0;
    self.leftMessageY = self.leftMessageView.frame.origin.y;
    
    self.userImageFirstFourthPageImage.alpha = 0;
    self.messageFirstFourthPageImage.alpha = 0;
    self.userImageSecondFourthPageImage.alpha = 0;
    self.messageSecondFourthPageImage.alpha = 0;
    
    [self.contentView bringSubviewToFront:self.contentView.fadeView];
    [self.contentView bringSubviewToFront:self.contentView.footerView];
    
    

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.alpha = 0;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.view.alpha = 1;
    }];
}

#pragma mark - User Interface

- (void)updateDataSource:(FRIntroDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


#pragma mark - IntroContentViewDelegate

- (void)setFirstPageAlpha:(CGFloat)alpha
{
    self.leftMessageView.alpha =
    self.centerMessageView.alpha =
    self.rightMessageView.alpha =
    self.contentView.page1.customPageView.titleLabel.alpha =
    self.contentView.page1.customPageView.subtitleLabel.alpha = alpha;
}

- (void) setSecondPageAlpha:(CGFloat)alpha
{
    self.contentView.page2.customPageView.alpha =
    self.contentView.page2.customPageView.titleLabel.alpha =
    self.contentView.page2.customPageView.subtitleLabel.alpha = alpha;
}

- (void)setThirdPageAlpha:(CGFloat)alpha
{
    self.contentView.page3.customPageView.alpha =
    self.contentView.page3.customPageView.titleLabel.alpha =
    self.contentView.page3.customPageView.subtitleLabel.alpha = alpha;
}

- (void)setFourthPageAlpha:(CGFloat)alpha
{
    self.contentView.page4.customPageView.alpha =
    self.contentView.page4.customPageView.titleLabel.alpha =
    self.contentView.page4.customPageView.subtitleLabel.alpha = alpha;
}

- (void)scrollViewPositionX:(CGFloat)positionX
{
   
    CGFloat x = positionX >= 0 ? positionX : 0;
    CGFloat w = self.screenWidth;
    
    if (x > 0 && x < w)
    {
        if (x > w / 4)
        {
            [self setFirstPageAlpha:0];
            self.pulseView.hidden = YES;
        }
        else
        {
            [self setFirstPageAlpha:(w / 10) /x];
            self.pulseView.hidden = NO;
            
            CGFloat topOffset = x > self.lastPositionX ? 20 : 0;
            [self firstPageSetTopOffset:topOffset];
        }
    }
    
    if (x > w / 2 && x < w)
    {
        if (x < w / 1.5)
        {
            [UIView animateWithDuration:.3 animations:^{
                [self setSecondPageAlpha:0];
            }];
        }
        else
        {
            [self setSecondPageAlpha:( (w / 10) / (w - x))];
        }
    }
    else if (x >= w  && x < w * 1.5)
    {
        [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth  key:@"userImageHeightConstraint"];
        [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset key:@"userPhotoTopOffset"];
        
        if (x > w * 1.3)
        {
            [UIView animateWithDuration:0.3 animations:^{
                [self setSecondPageAlpha:0];
            }];
        }
        else
        {
            [self setSecondPageAlpha:((w / 10) / (x - w))];
        }
    }

    
    if (x > w  && x < w * 2)
    {
        if (x >= self.lastPositionX)
        {
            [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 20 key:@"userImageHeightConstraint" velocity:15];
            [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 20 key:@"userPhotoTopOffset" velocity:15];
        } else {
            [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth  key:@"userImageHeightConstraint"];
            [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset key:@"userPhotoTopOffset"];

            [UIView animateWithDuration:0.4 animations:^{
                self.firstBigMessageView.alpha = 0;
            } completion:^(BOOL finished) {
                
                self.secondBigMessageView.alpha = 0;
            }];
            
        }
        
        if (x < w * 1.6)
        {
            [UIView animateWithDuration:.3 animations:^{
                [self setThirdPageAlpha:0];
            }];
        }
        else
        {
            [self setThirdPageAlpha:((w / 10) / (w * 2 - x))];
        }
        
    }
    else if (x >= w*2 && x < w * 2.5)
    {
        if (x > w * 2.3)
        {
            
            [UIView animateWithDuration:0.3 animations:^{
                [self setThirdPageAlpha:0];
            }];
        }
        else
        {
            [self setThirdPageAlpha:((w / 10) / (x - w * 2))];
            
                [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 20 key:@"userImageHeightConstraint"];
                [FRAnimator animateConstraint:self.userImageLeftOffsetConstraint newOffset:0 key:@"userImageLeftOffsetConstraint"];
                [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 20 key:@"userPhotoTopOffset"];
                
                self.countMessageView.alpha = 1;
            
                [UIView animateWithDuration:0.4 animations:^{
                    
                    self.firstBigMessageView.alpha = 0;
                } completion:^(BOOL finished) {
//                    [UIView animateWithDuration:0 animations:^{
                        self.secondBigMessageView.alpha = 0;
//                    }];
                }];
                
                [FRAnimator animateConstraint:self.firstBigMessageViewTopConstraint newOffset:kHeight / 2.72 key:@"firstBigMessageViewTopConstraint" delay:0 bouncingRate:1 completion:^{
                    
                    [UIView animateWithDuration:0.8 animations:^{
                        
                        self.secondBigMessageView.alpha = 1;
                    }];
                    
                    [FRAnimator animateConstraint:self.secondBigMessageViewTopConstraint newOffset:kHeight / 2.1 key:@"secondBigMessageViewTopConstraint"];
                }];
            
            
        }
    }
    
    if (x > w * 2.5  && x < w * 3)
    {
        
        [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 20 key:@"userImageHeightConstraint"];
        [FRAnimator animateConstraint:self.userImageLeftOffsetConstraint newOffset:0 key:@"userImageLeftOffsetConstraint"];
        [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 20 key:@"userPhotoTopOffset"];
        
        if (x < w * 2.8)
        {
            
            [UIView animateWithDuration:.3 animations:^{
                [self setFourthPageAlpha: 0];
            }];
        }
        else
        {
            [UIView animateWithDuration:0.3 animations:^{
                
                self.contentView.page4.customPageView.contentView.alpha = ((w / 10) / (w * 3 - x));
            }];
            
            [self setFourthPageAlpha:((w / 10) / (w * 3 - x))];
            
            [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 40 key:@"userImageHeightConstraint"];
            [FRAnimator animateConstraint:self.userImageLeftOffsetConstraint newOffset: -(self.screenWidth / 2) + 50 key:@"userImageLeftOffsetConstraint"];
            [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 5 key:@"userPhotoTopOffset"];
            
        }
    }
    
    
//    self.firstBigMessageView.alpha = 0;
//    self.secondBigMessageView.alpha = 0;
    
    [FRAnimator animateConstraint:self.firstBigMessageViewTopConstraint newOffset:kHeight / 2.5 key:@"firstBigMessageViewTopConstraint"];
    
    [FRAnimator animateConstraint:self.secondBigMessageViewTopConstraint newOffset:kHeight / 1.9 key:@"secondBigMessageViewTopConstraint"];
    
    [FRAnimator animateConstraint:self.countMessageViewConstraint newOffset:0 key:@"self.countMessageViewConstraint"];
    self.countMessageView.alpha = 0;
    [self.countMessageView.layer removeAllAnimations];
    
    
    self.userImageFirstFourthPageImage.alpha = 0;
    self.messageFirstFourthPageImage.alpha = 0;
    self.userImageSecondFourthPageImage.alpha = 0;
    self.messageSecondFourthPageImage.alpha = 0;
    
    [FRAnimator animateConstraint:self.heightFirstUserImageFoutthConstraint newOffset:0 key:@"heightFirstUserImageFoutthConstraint"];
    [FRAnimator animateConstraint:self.rightFirstMessageFoutthConstraint newOffset: -20 key:@"rightFirstMessageFoutthConstraint"];
    [FRAnimator animateConstraint:self.heightSecondUserImageFoutthConstraint newOffset:0 key:@"heightSecondUserImageFoutthConstraint"];
    [FRAnimator animateConstraint:self.leftSecondMessageFoutthConstraint newOffset: 20 key:@"rightFirstMessageFoutthConstraint"];
    
    
    [self.userImageSecondFourthPageImage.layer removeAllAnimations];
    [self.userImageFirstFourthPageImage.layer removeAllAnimations];
    
    if (x == 0)
    {
        [self pause];
        [self firstPageSetTopOffset:0];
    }
    
    else if (x == w)
    {
        [self pause];
        [self.userImage.layer removeAllAnimations];
        
        [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth  key:@"userImageHeightConstraint"];
        [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset key:@"userPhotoTopOffset"];
        
    }
    else if (x == w * 2)
    {
        [self pause];
        BSDispatchBlockAfter(0.4, ^{
            
            [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 20 key:@"userImageHeightConstraint"];
            [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 20 key:@"userPhotoTopOffset"];
            
            [FRAnimator animateConstraint:self.userImageHeightConstraint newOffset:self.userPhotoWidth - 20 key:@"userImageHeightConstraint"];
            [FRAnimator animateConstraint:self.userImageLeftOffsetConstraint newOffset:0 key:@"userImageLeftOffsetConstraint"];
            [FRAnimator animateConstraint:self.userImageTopConstraint newOffset:self.userPhotoTopOffset - 20 key:@"userPhotoTopOffset"];
            
            self.countMessageView.alpha = 1;
            
            [FRAnimator animateConstraint:self.countMessageViewConstraint newOffset:kHeight/15.16 key:@"self.countMessageViewConstraint" delay:0 bouncingRate:20 completion:^{
               
                CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"bounds"];
                boundsAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kHeight/15.16, kHeight/15.16)];
                boundsAnim.toValue = [NSValue valueWithCGRect:CGRectMake(0, 0, kHeight/18.16, kHeight/18.16)];
                boundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
                boundsAnim.duration = 0.5;
                boundsAnim.autoreverses = YES;
                boundsAnim.repeatCount = INFINITY;
                [self.countMessageView.layer addAnimation:boundsAnim forKey:@"boundsAnim"];
            }];

                [UIView animateWithDuration:0.8 animations:^{
                    
                    self.firstBigMessageView.alpha = 1;
                }];
            
                    [FRAnimator animateConstraint:self.firstBigMessageViewTopConstraint newOffset:kHeight / 2.72 key:@"firstBigMessageViewTopConstraint" delay:0 bouncingRate:1 completion:^{
                        
                        [UIView animateWithDuration:0.8 animations:^{
                            
                            self.secondBigMessageView.alpha = 1;
                        }];
                        
                        [FRAnimator animateConstraint:self.secondBigMessageViewTopConstraint newOffset:kHeight / 2.1 key:@"secondBigMessageViewTopConstraint"];
                    }];
        });
        
    }
    else if (x == w * 3)
    {
        [self pause];
            self.firstBigMessageView.alpha = 0;
            self.secondBigMessageView.alpha = 0;
        
        self.userImageFirstFourthPageImage.alpha = 1;
        [self.userImageFirstFourthPageImage.layer addAnimation:[self bounces] forKey:@"userImageFirstFourthPageImage"];
        
       [FRAnimator animateConstraint:self.heightFirstUserImageFoutthConstraint newOffset:0 key:@"heightFirstUserImageFoutthConstraint" delay:0.2 bouncingRate:20 completion:^{
          
           [UIView animateWithDuration:0.5 animations:^{
               
               self.messageFirstFourthPageImage.alpha = 1;
           }];
           [FRAnimator animateConstraint:self.rightFirstMessageFoutthConstraint newOffset:2 key:@"rightFirstMessageFoutthConstraint" delay:.1 bouncingRate:5 completion:^{
              
               
               [self.userImageSecondFourthPageImage.layer addAnimation:[self bounces] forKey:@"userImageSecondFourthPageImage"];
                   self.userImageSecondFourthPageImage.alpha = 1;
               
               [FRAnimator animateConstraint:self.heightSecondUserImageFoutthConstraint newOffset: 0 key:@"heightSecondUserImageFoutthConstraint" delay:0.1 bouncingRate:20 completion:^{
                  
                   [UIView animateWithDuration:0.5 animations:^{
                       
                       self.messageSecondFourthPageImage.alpha = 1;
                   }];
                   [FRAnimator animateConstraint:self.leftSecondMessageFoutthConstraint newOffset:2 key:@"leftMessageViewTopConstraint" delay:0.1 bouncingRate:5 completion:nil];
               }];
               
           }];
           
           
       }];
        
    }
    
     self.lastPositionX = positionX;
}

- (void)pause
{
    self.view.userInteractionEnabled = NO;
    BSDispatchBlockAfter(0.5, ^{
        self.view.userInteractionEnabled = YES;
    });
}

- (CABasicAnimation*)bounces
{
    CABasicAnimation* boundsAnim = [CABasicAnimation animationWithKeyPath: @"bounds"];
    boundsAnim.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)];
    boundsAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    boundsAnim.duration = 0.3;
    
    return boundsAnim;
}


- (void)firstPageSetTopOffset:(CGFloat)topOffset
{
//    [FRAnimator animateConstraint:self.leftMessageViewTopConstraint newOffset:kLeftTopOffset + topOffset key:@"leftMessageViewTopConstraint"];
//    [FRAnimator animateConstraint:self.centerMessageViewTopConstraint newOffset:kCenterTopOffset + topOffset key:@"centerMessageViewTopConstraint"];
//    [FRAnimator animateConstraint:self.rightMessageViewTopConstraint newOffset:kRightTopOffset + topOffset key:@"rightMessageViewTopConstraint"];
}

#pragma mark - FRTableController Delegate


#pragma mark - Lazy Load

- (UIImageView*)userImage
{
    if (!_userImage)
    {
        _userImage = [UIImageView new];
        _userImage.image = [UIImage imageNamed:@"Login-flow_ Main user"];
        [self.view addSubview:_userImage];
        
        [_userImage mas_makeConstraints:^(MASConstraintMaker *make) {
            self.userImageHeightConstraint =  make.height.equalTo(@(self.userPhotoWidth));
            make.width.equalTo(_userImage.mas_height);
            self.userImageLeftOffsetConstraint =  make.centerX.equalTo(self.view);
            self.userImageTopConstraint = make.top.equalTo(self.contentView).offset(self.userPhotoTopOffset);
        }];
    }
    return _userImage;
}

- (FRIntroMessageBaseView*)leftMessageView
{
    if (!_leftMessageView)
    {
        _leftMessageView = [[FRIntroMessageBaseView alloc]initWithUserImage:[UIImage imageNamed:@"Login-flow_ user 2"] clockwose:NO];
        [self.view addSubview:_leftMessageView];
        
        [_leftMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            self.leftMessageViewTopConstraint = make.top.equalTo(self.userImage.mas_bottom).offset(4);
            make.right.equalTo(self.userImage.mas_left).offset(-5);
            make.height.equalTo(@(self.messageWidth/2));
            make.width.equalTo(@(self.messageWidth));
        }];
    }
    return _leftMessageView;
}

- (FRIntroMessageBaseView*)centerMessageView
{
    if (!_centerMessageView)
    {
        _centerMessageView = [[FRIntroMessageBaseView alloc]initWithUserImage:[UIImage imageNamed:@"Login-flow_ user 3"] clockwose:YES];
        [self.view addSubview:_centerMessageView];
        
        [_centerMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            self.centerMessageViewTopConstraint = make.top.equalTo(self.userImage.mas_bottom).offset(70);
            make.centerX.equalTo(self.userImage);
            make.height.equalTo(@(self.messageWidth/2));
            make.width.equalTo(@(self.messageWidth));
        }];
    }
    return _centerMessageView;
}

- (FRIntroMessageBaseView*)rightMessageView
{
    if (!_rightMessageView)
    {
        _rightMessageView = [[FRIntroMessageBaseView alloc]initWithUserImage:[UIImage imageNamed:@"Login-flow_ user 1"]clockwose:NO];
        [self.view addSubview:_rightMessageView];
        
        [_rightMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            self.rightMessageViewTopConstraint = make.top.equalTo(self.userImage.mas_bottom).offset(-5);
            make.left.equalTo(self.userImage.mas_right).offset(5);
            make.height.equalTo(@(self.messageWidth/2));
            make.width.equalTo(@(self.messageWidth));
        }];
    }
    return _rightMessageView;
}

- (UIImageView*)firstBigMessageView
{
    if (!_firstBigMessageView)
    {
        _firstBigMessageView = [UIImageView new];
        _firstBigMessageView.image = [UIImage imageNamed:@"Login-flow_ Request"];
        _firstBigMessageView.contentMode = UIViewContentModeScaleToFill;
        
        UIImageView* image = [UIImageView new];
        image.image = [UIImage imageNamed:@"Login-flow_ user 3"];
        [_firstBigMessageView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_firstBigMessageView);
            make.left.equalTo(_firstBigMessageView).offset(30);
            make.width.height.equalTo(_firstBigMessageView.mas_height).multipliedBy(.5);
        }];
        
        [self.view addSubview:_firstBigMessageView];
        
        [_firstBigMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat height = kHeight / 7.41;
            make.height.equalTo(@(height));
            make.width.equalTo(@(height * 3.8));
            self.firstBigMessageViewTopConstraint = make.top.equalTo(self.view).offset(kHeight / 2.5);//for iphone 6 == 245
            make.centerX.equalTo(self.view);
        }];
    }
    return _firstBigMessageView;
}

- (UIImageView*)secondBigMessageView
{
    if (!_secondBigMessageView)
    {
        _secondBigMessageView = [UIImageView new];
        _secondBigMessageView.image = [UIImage imageNamed:@"Login-flow_ Request"];
        _secondBigMessageView.contentMode = UIViewContentModeScaleToFill;
        
        UIImageView* image = [UIImageView new];
        image.image = [UIImage imageNamed:@"Login-flow_ user 2"];
        [_secondBigMessageView addSubview:image];
        
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_secondBigMessageView);
            make.left.equalTo(_secondBigMessageView).offset(30);
            make.width.height.equalTo(_secondBigMessageView.mas_height).multipliedBy(.5);
        }];
        
        [self.view addSubview:_secondBigMessageView];
        
        [_secondBigMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat height = kHeight / 7.41;
            make.height.equalTo(@(height));
            make.width.equalTo(@(height * 3.8));
            self.secondBigMessageViewTopConstraint = make.top.equalTo(self.view).offset(kHeight / 2.);//for iphone 6 == 245
            make.centerX.equalTo(self.view);
        }];
    }
    return _secondBigMessageView;
}

- (UIImageView*)countMessageView
{
    if (!_countMessageView)
    {
        _countMessageView = [UIImageView new];
        _countMessageView.image = [UIImage imageNamed:@"Login-flow_ Notification"];
        
        
        [self.view addSubview:_countMessageView];
        
        [_countMessageView mas_makeConstraints:^(MASConstraintMaker *make) {
            self.countMessageViewConstraint = make.height.equalTo(@(kHeight/15.16));
            make.width.equalTo(_countMessageView.mas_height);
            CGFloat temp = IS_IPHONE_5_OR_HIGHER ? 44.46 : 20;
            make.centerY.equalTo(self.userImage.mas_bottom).offset(- kHeight /temp);
            make.centerX.equalTo(self.userImage.mas_right).offset(kHeight/26.68);
        }];
    }
    return _countMessageView;
}


- (UIImageView*)userImageFirstFourthPageImage
{
    if (!_userImageFirstFourthPageImage)
    {
        _userImageFirstFourthPageImage = [UIImageView new];
        _userImageFirstFourthPageImage.image = [UIImage imageNamed:@"Login-flow_ user 1"];
        
        [self.view addSubview:_userImageFirstFourthPageImage];
        
        [_userImageFirstFourthPageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.view).offset(-30);
            make.top.equalTo(self.userImage.mas_bottom).offset(20);
            make.width.equalTo(self.userImage);
            self.heightFirstUserImageFoutthConstraint = make.height.equalTo(_userImageFirstFourthPageImage.mas_width);
        }];
    }
    return _userImageFirstFourthPageImage;
}

- (UIImageView*)messageFirstFourthPageImage
{
    if (!_messageFirstFourthPageImage)
    {
        _messageFirstFourthPageImage = [UIImageView new];
        _messageFirstFourthPageImage.contentMode = UIViewContentModeScaleAspectFit;
        _messageFirstFourthPageImage.image = [UIImage imageNamed:@"Login-flow_ Message 2"];
        [self.view addSubview:_messageFirstFourthPageImage];
        
        [_messageFirstFourthPageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userImageFirstFourthPageImage);
            make.height.equalTo(self.userImageFirstFourthPageImage).multipliedBy(1.85);
            self.rightFirstMessageFoutthConstraint = make.right.equalTo(self.userImageFirstFourthPageImage.mas_left).offset(2);
            make.width.equalTo(_messageFirstFourthPageImage.mas_height).multipliedBy(3);
            
        }];
    }
    return _messageFirstFourthPageImage;
}

- (UIImageView*)userImageSecondFourthPageImage
{
    if (!_userImageSecondFourthPageImage)
    {
        _userImageSecondFourthPageImage = [UIImageView new];
        _userImageSecondFourthPageImage.image = [UIImage imageNamed:@"Login-flow_ user 3"];
        
        [self.view addSubview:_userImageSecondFourthPageImage];
        
        [_userImageSecondFourthPageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            CGFloat temp = 30;
            
            if (IS_IPHONE_6_PLUS) {
                temp = 23;
            }
            
            make.left.equalTo(self.view).offset(temp);
            
            CGFloat offset = 7.41;
            if ([[UIScreen mainScreen] bounds].size.height <= 568.0f)
            {
                offset = 8.9;
            }
            
            make.top.equalTo(self.userImage.mas_bottom).offset(kHeight / offset);
            make.width.equalTo(self.userImage);
            self.heightSecondUserImageFoutthConstraint = make.height.equalTo(_userImageFirstFourthPageImage.mas_width);
        }];
    }
    return _userImageSecondFourthPageImage;
}

- (UIImageView*)messageSecondFourthPageImage
{
    if (!_messageSecondFourthPageImage)
    {
        _messageSecondFourthPageImage = [UIImageView new];
        _messageSecondFourthPageImage.contentMode = UIViewContentModeScaleAspectFit;
        _messageSecondFourthPageImage.image = [UIImage imageNamed:@"Login-flow_ Message 3"];
        [self.view addSubview:_messageSecondFourthPageImage];
        [_messageSecondFourthPageImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            CGFloat temp = IS_IPHONE_5_OR_HIGHER ? 15 : 25;
            if (IS_IPHONE_6) {
                temp = 10;
            }
            
            
            make.centerY.equalTo(self.userImageSecondFourthPageImage).offset(temp);
            make.height.equalTo(self.userImageSecondFourthPageImage).multipliedBy(1.85);
            self.leftSecondMessageFoutthConstraint = make.left.equalTo(self.userImageSecondFourthPageImage.mas_right).offset(2);
            make.width.equalTo(_messageSecondFourthPageImage.mas_height).multipliedBy(2.75);
            
        }];
    }
    return _messageSecondFourthPageImage;
}


@end
