//
//  FRIntroContentView.m
//  Friendly
//
//  Created by Sergey Borichev on 28.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRIntroContentView.h"
#import "FRStyleKit.h"
#import "FRAnimator.h"
#import "EAIntroView.h"
#import "FRBasePageView.h"
#import "FRPageView.h"
#import "UIImageHelper.h"

@interface FRIntroContentView () <EAIntroDelegate>

@property (nonatomic, strong) EAIntroView* headerView;


@property (nonatomic, strong) UIButton* privacyButton;
@property (nonatomic, strong) UILabel* privacyLabel;
@property (nonatomic, strong) UIImageView* privacyImage;
@property (nonatomic, strong) UIButton* closePrivacyButton;


@property (nonatomic, strong) MASConstraint* footerHeightConstraint;
@property (nonatomic, strong) MASConstraint* topLoginButtonConstraint;

@end

#define kHeight [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width

@implementation FRIntroContentView


- (instancetype)init
{
    self = [super init];
    if (self)
    {
  
        self.headerView.backgroundColor = [UIColor greenColor];
        self.fadeView.hidden = YES;
        [self.privacyButton addTarget:self action:@selector(pravicyAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.closePravicyButton addTarget:self action:@selector(closeAction:) forControlEvents:UIControlEventTouchUpInside];

        [self hiddenPrivacyView:YES];
    }
    return self;
}



#pragma mark - EAIntroDelegate

- (void)scroll:(CGFloat)positionX
{
    [self.delegate scrollViewPositionX:positionX];
}


#pragma mark - Action
         
- (void)pravicyAction:(UIButton*)sender
{
    
    
    self.fadeView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.fadeView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    } completion:^(BOOL finished) {
    
    
        BSDispatchBlockAfter(0.3, ^{
            
            [UIView animateWithDuration:0.3 animations:^{
                
                [self hiddenPrivacyView:NO];
            }];
        });
    }];
            [FRAnimator animateConstraint:self.footerHeightConstraint newOffset:400 key:@"footerHeightConstraint"];
            [FRAnimator animateConstraint:self.topLoginButtonConstraint newOffset:45 key:@"topLoginButtonConstraint"];
    
    
}

- (void)closeAction:(UIButton*)sender
{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.fadeView.backgroundColor = [UIColor clearColor];
    } completion:^(BOOL finished) {
        self.fadeView.hidden = YES;
    }];
    
    [self hiddenPrivacyView:YES];
    [FRAnimator animateConstraint:self.footerHeightConstraint newOffset:115 key:@"footerHeightConstraint"];
    [FRAnimator animateConstraint:self.topLoginButtonConstraint newOffset:22 key:@"topLoginButtonConstraint"];
}

- (NSAttributedString*)string:(NSString*)text lineSpacing:(CGFloat)lineSpacing
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, text.length)];
    
    return  attributedString;
}

- (void)closePrivacy
{
    [self closeAction:nil];
}

- (void)hiddenPrivacyView:(BOOL)isHide
{
    self.privacyButton.hidden = !isHide;
    self.closePrivacyButton.hidden = isHide;
    self.closePrivacyButton.hidden = isHide;
    self.privacyLabel.hidden = isHide;
    self.privacyImage.hidden = isHide;
}


#pragma mark - Lazy Load

- (FRPageView*)page1
{
    if (!_page1)
    {
        _page1= [[FRPageView alloc]initWithTitle:FRLocalizedString(@"Make new friends through \n nearby events", nil) subTitle:FRLocalizedString(@"Join an event that suits your interests, or \n just some of your own", nil)];
    }
    return _page1;
}

- (FRPageView*)page2
{
    if (!_page2)
    {
        _page2 = [[FRPageView alloc]initWithTitle:FRLocalizedString(@"Create any type of event that\ncomes to mind", nil) subTitle:FRLocalizedString(@"Put up the velvet ropes & create a private\nevent for up to 20, or just for two", nil)];
        
        UIImageView* image = [UIImageView new];
        image.contentMode = UIViewContentModeScaleAspectFit;
        image.image = [UIImage imageNamed:@"Login-flow_ Card Large"];
        image.userInteractionEnabled = YES;
        [_page2.customPageView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_page2.customPageView);
            make.right.equalTo(_page2.customPageView);
            make.top.equalTo(_page2.customPageView).offset(kHeight/3.335); // for iphone 6 == 200
            make.height.equalTo(image.mas_width).multipliedBy(0.5);
        }];
        
    }
    return _page2;
}

- (FRPageView*)page3
{
    if (!_page3)
    {
        _page3 = [[FRPageView alloc]initWithTitle:FRLocalizedString(@"Have others approach you\nthrough your event", nil) subTitle:FRLocalizedString(@"Hopeful guests tell you why they want to\ncome you decide if they're a good fit", nil)];
        
        UIImageView* image = [UIImageView new];
        image.image = [UIImage imageNamed:@"Login-flow_ Card 3"];
        image.userInteractionEnabled = YES;
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width / 2.5;
        
        
        [_page3.customPageView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            
            CGFloat heightFactor = IS_IPHONE_5_OR_HIGHER ? 3.6 : 3.85;
            
            make.top.equalTo(_page3.customPageView).offset(kHeight / heightFactor); // for iphone 6 == 185
            make.centerX.equalTo(_page3.customPageView);
            make.width.equalTo(@(width));
            make.height.equalTo(image.mas_width).multipliedBy(0.5);
        }];
    }
    return _page3;
}

- (FRPageView*)page4
{
    if (!_page4)
    {
       _page4 = [[FRPageView alloc]initWithTitle:FRLocalizedString(@"Break the ice before the day\nwith group chat", nil) subTitle:FRLocalizedString(@"A place where everyone can get\nacquainted and plan for the big day", nil)];
        
        UIImageView* image = [UIImageView new];
        image.image = [UIImage imageNamed:@"Login-flow_ Message 1"];
        image.userInteractionEnabled = YES;
        
        CGFloat width = kWidth / 1.7;
        
        [_page4.customPageView.contentView addSubview:image];
        [image mas_makeConstraints:^(MASConstraintMaker *make) {
            
        
            
            CGFloat topOffset = 0;
            CGFloat leftOffset = 5.1;
            if ([[UIScreen mainScreen] bounds].size.height <= 568.0f)
            {
                topOffset = 5;
                leftOffset = 4.9;
            }
            
        
            make.centerY.equalTo(_page4.customPageView.mas_top).offset(kHeight / 3.5 - topOffset ); // for iphone 6 == 163
            make.left.equalTo(_page4.customPageView.contentView).offset(kWidth / leftOffset); //for iphone 6 = 70
            make.width.equalTo(@(width));
            make.height.equalTo(@(kHeight/13.34));
        }];

    }
    return _page4;
}

- (EAIntroView*)headerView
{
    if (!_headerView)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        frame.size.height -= 115;
        _headerView = [[EAIntroView alloc] initWithFrame:frame andPages:@[self.page1, self.page2, self.page3, self.page4]];
        _headerView.delegate = self;
        _headerView.swipeToExit = NO;
        _headerView.skipButton.hidden = YES;
        _headerView.tapToNext = YES;
        _headerView.pageControl.pageIndicatorTintColor = [[UIColor bs_colorWithHexString:@"#9CA0AB"] colorWithAlphaComponent:0.2];
        _headerView.pageControl.currentPageIndicatorTintColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [_headerView.pages enumerateObjectsUsingBlock:^(FRPageView* obj, NSUInteger idx, BOOL * _Nonnull stop) {
          
            [obj.pageView addSubview:obj.customPageView];
            [obj.customPageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(obj.pageView);
            }];
        }];
        
        
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        _headerView.scrollView.contentSize = (CGSize){width * 4, 0};
        [self addSubview:_headerView];
        
        [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self);
            make.bottom.equalTo(self).offset(-105);
        }];
    }
    return _headerView;
}

- (UIView*)footerView
{
    if (!_footerView)
    {
        _footerView = [UIView new];
        _footerView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_footerView];
        
        [_footerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self);
            self.footerHeightConstraint = make.height.equalTo(@115);
        }];
    }
    return _footerView;
}

- (UIButton*)loginButton
{
    if (!_loginButton)
    {
        _loginButton = [UIButton new];
        [_loginButton setTitle:FRLocalizedString(@"Log in with Facebook", nil) forState:UIControlStateNormal];
        _loginButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_loginButton setImage:[FRStyleKit imageOfCombinedShapeCanvas5] forState:UIControlStateNormal];
        [_loginButton setImage:[UIImageHelper image:[FRStyleKit imageOfCombinedShapeCanvas5] color:[[UIColor whiteColor] colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
        _loginButton.titleEdgeInsets = UIEdgeInsetsMake(0, 18.5, 0, 0);
        _loginButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _loginButton.layer.cornerRadius = 6;
        [self.footerView addSubview:_loginButton];
        
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.footerView).offset(47.5);
            make.right.equalTo(self.footerView).offset(-47.5);
            self.topLoginButtonConstraint = make.top.equalTo(self.footerView).offset(22);
            make.height.equalTo(@50);
        }];
    }
    return _loginButton;
}

- (UIButton*)privacyButton
{
    if (!_privacyButton)
    {
        _privacyButton = [UIButton new];
        [_privacyButton setTitle:FRLocalizedString(@"intro.vc.privacyButton.title", nil) forState:UIControlStateNormal];
//        [_privacyButton setImage:[FRStyleKit imageOfInfoCanvas] forState:UIControlStateNormal];
        _privacyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _privacyButton.titleLabel.adjustsFontSizeToFitWidth = YES;
//        _privacyButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        
        [_privacyButton.titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(13)];
        _privacyButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);

        
        
        [_privacyButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal];
        
        [self.footerView addSubview:_privacyButton];
        
        [_privacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.loginButton);
            make.height.equalTo(@30);
            make.top.equalTo(self.loginButton.mas_bottom).offset(1);
        }];
    }
    return _privacyButton;
}

//- (UIImageView*)privacyImage
//{
//    if (!_privacyImage)
//    {
//        _privacyImage = [UIImageView new];
//        _privacyImage.image = [FRStyleKit imageOfInfoCanvas];
//        [self.footerView addSubview:_privacyImage];
//        
//        [_privacyImage mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.loginButton.mas_bottom).offset(34);
//            make.height.width.equalTo(@20);
//            make.centerX.equalTo(self.footerView);
//        }];
//    }
//    return _privacyImage;
//}

- (UILabel*)privacyLabel
{
    if (!_privacyLabel)
    {
        _privacyLabel = [UILabel new];
        _privacyLabel.attributedText = [self string:FRLocalizedString(@"intro.vc.privacyTextView", nil) lineSpacing:7];
        _privacyLabel.textAlignment = NSTextAlignmentCenter;
        _privacyLabel.font = FONT_SF_DISPLAY_REGULAR(14);
        _privacyLabel.adjustsFontSizeToFitWidth = YES;
        _privacyLabel.numberOfLines = 11;
        _privacyLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        
        
        [self.footerView addSubview:_privacyLabel];
        
        [_privacyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(35);
            make.left.equalTo(self.footerView).offset(30);
            make.right.equalTo(self.footerView).offset(-30);
        }];
        
    }
    return _privacyLabel;
}

- (UIButton*)closePravicyButton
{
    if (!_closePrivacyButton)
    {
        _closePrivacyButton = [UIButton new];
        [_closePrivacyButton setImage:[FRStyleKit imageOfActionBarLeaveEventCanvas] forState:UIControlStateNormal];
        [_closePrivacyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [self.footerView addSubview:_closePrivacyButton];
        
        [_closePrivacyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@30);
            make.width.equalTo(@30);
            make.top.equalTo(self.footerView).offset(10);
            make.left.equalTo(self.footerView).offset(10);
        }];
    }
    return _closePrivacyButton;
}


- (UIView*)fadeView
{
    if (!_fadeView)
    {
        _fadeView = [UIView new];
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction:)];
        [_fadeView addGestureRecognizer:gest];
        _fadeView.backgroundColor = [UIColor clearColor];

        [self addSubview:_fadeView];
        
        [_fadeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self);
        }];
    }
    return _fadeView;
}



@end
