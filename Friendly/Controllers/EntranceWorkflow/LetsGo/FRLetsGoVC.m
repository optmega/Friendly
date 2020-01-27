//
//  FRLetsGoVC.m
//  Friendly
//
//  Created by Sergey Borichev on 03.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRLetsGoVC.h"
#import "FRLetsGoContentView.h"
#import "FRAddInterestsWireframe.h"
#import "FRAnimator.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FRLetsGoVC ()

@property (nonatomic, strong) FRLetsGoContentView* contentView;

@end

@implementation FRLetsGoVC

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.contentView = [FRLetsGoContentView new];
    }
    return self;
}

- (void)loadView
{
    self.view = self.contentView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    @weakify(self);
    [[self.contentView.letsGoButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        APP_DELEGATE.state = RegistrationStateMiddleRegistration;
        [[FRAddInterestsWireframe new] presentAddInterestsControllerFromNavigationController:self.navigationController];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setContentViewOpasity:0];
    self.view.alpha = 0;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    NSURL* url = [NSURL URLWithString:[FRUserManager sharedInstance].userModel.photo];
    
//    [self.contentView.photo sd_setImageWithURL:url placeholderImage:[FRUserManager sharedInstance].logoImage];
    
    CGFloat imageWidth = [UIScreen mainScreen].bounds.size.width / 8;
    
    if (IS_IPHONE_5_OR_HIGHER) {
        
        imageWidth = 75;
    }
    
    
    CGFloat x = (([UIScreen mainScreen].bounds.size.width - imageWidth)/2);
    UIImageView* circle = [[UIImageView alloc] initWithFrame:CGRectMake(x, 120, imageWidth, imageWidth)];
    [circle.layer setCornerRadius:circle.frame.size.width / 2];
    circle.layer.borderColor = [UIColor whiteColor].CGColor;
    circle.layer.borderWidth = 3;
    circle.clipsToBounds = YES;
    
    [UIView animateWithDuration:0.6 animations:^{
        self.view.alpha = 1;
    } completion:^(BOOL finished)
     {
         
         //            [FRAnimator animateConstraint:self.contentView.heightConstraint newOffset:150 key:@"contentView.heightConstraint" delay:0.3 bouncingRate:15 completion:^{
         
                     [UIView animateWithDuration:0.5 animations:^{
                 [self setContentViewOpasity:1];
             }];
         [circle sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
          {
              [self.view addSubview:circle];
              
              [UIView animateWithDuration:1 animations:^{
                  // Animate it to double the size
                  const CGFloat scale = 2;
                  [circle setTransform:CGAffineTransformMakeScale(scale, scale)];
              }];
          }];

             
         }];

    
    
//    [self.contentView.photo sd_setImageWithURL:url placeholderImage:[FRUserManager sharedInstance].logoImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
       //        }];
        //
//    }];
    
}

- (void)setContentViewOpasity:(CGFloat)alpha
{
    self.contentView.letsGoButton.alpha =
//    self.contentView.photo.alpha =
    self.contentView.smileLabel.alpha =
    self.contentView.smile.alpha =
    self.contentView.contentLabel.alpha = alpha;

}

@end
