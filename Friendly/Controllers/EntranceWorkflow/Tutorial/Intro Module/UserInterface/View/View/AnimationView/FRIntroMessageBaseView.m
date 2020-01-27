//
//  fff.m
//  Friendly
//
//  Created by Sergey Borichev on 27.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRIntroMessageBaseView.h"

@interface FRIntroMessageBaseView ()

@property (nonatomic ,strong) UIImageView *dialogImageView;
@property (nonatomic ,strong) UIImageView *userPhotoImageView;
@property (nonatomic, assign) NSInteger speed;
@property (nonatomic, strong) UIImage* dialogImage;

@end

@implementation FRIntroMessageBaseView


- (instancetype)initWithUserImage:(UIImage*)userImage clockwose:(BOOL)isClockwise
{
    self = [super init];
    if (self)
    {
        self.userPhotoImageView.image = userImage;
        self.backgroundColor = [UIColor clearColor];
        self.dialogImageView.image = isClockwise ? [UIImage imageNamed:@"Login-flow_ Card 2"] : [UIImage imageNamed:@"Login-flow_ Card"];
        self.speed = isClockwise ? 1 : -1;
    }
    return self;
}

- (UIImageView*)dialogImageView
{
    if (!_dialogImageView)
    {
        _dialogImageView = [UIImageView new];
//        _dialogImageView.image = self.dialogImage;
        _dialogImageView.contentMode = UIViewContentModeScaleAspectFill;
        _dialogImageView.userInteractionEnabled = YES;
        [self addSubview:_dialogImageView];
        
        [_dialogImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _dialogImageView;
}

- (UIImageView*)userPhotoImageView
{
    if (!_userPhotoImageView)
    {
        _userPhotoImageView = [UIImageView new];
        _userPhotoImageView.userInteractionEnabled = YES;
        [self.dialogImageView addSubview:_userPhotoImageView];
        
        [_userPhotoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.dialogImageView);
            make.centerY.equalTo(self.dialogImageView.mas_top);
            make.width.height.equalTo(self.dialogImageView.mas_height).multipliedBy(0.85);
        }];
    }
    return _userPhotoImageView;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.layer removeAllAnimations];
    
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    pathAnimation.calculationMode = kCAAnimationPaced;
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = INFINITY;
    pathAnimation.speed = self.speed;
    
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.duration = 4.;
    
    CGMutablePathRef curvedPath = CGPathCreateMutable();
    
    
    CGRect circleContainer = CGRectMake(self.frame.origin.x + 50, self.frame.origin.y +20, 5, 5);
    
    CGPathAddEllipseInRect(curvedPath, NULL, circleContainer);
    
    pathAnimation.path = curvedPath;
    CGPathRelease(curvedPath);
    
    [self.layer addAnimation:pathAnimation forKey:@"myCircleAnimation"];
    
}


@end
