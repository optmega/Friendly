 //
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersVC.h"
#import "FRRecommendedUsersController.h"
#import "FRRecommendedUsersDataSource.h"
#import "FRRecommendedUsersContentView.h"
#import "FRFooterQuestionairView.h"
#import "FRHeaderQuestionairView.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"
#import "NSString+SizeFit.h"


@interface FRRecommendedUsersVC () <BSTableControllerScrollDelegate>

@property (nonatomic, strong) FRRecommendedUsersController* controller;
@property (nonatomic, strong) FRRecommendedUsersContentView* contentView;
@property (nonatomic, strong) UIButton* backButton;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UILabel* titleLabel;

@property (nonatomic, strong) UIImageView* header;

@end

static CGFloat const kAnimationDuration = 0.7;
static CGFloat const kMinOpasity = 0.15;

@implementation FRRecommendedUsersVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRRecommendedUsersController alloc] initWithTableView:self.contentView.tableView];
        self.controller.recommendedScrollDeletage = self;
        self.controller.scrollDelegate = self;
        self.statusBarBackgraundView.backgroundColor = [[UIColor bs_colorWithHexString:@"FF75D4"]colorWithAlphaComponent:0.6];
        
    }
    return self;
}

//- (void)setAddFriendsMode:(BOOL)isAddFriends {
//    self.isAddFriends = isAddFriends;
//    
//    if (self.isAddFriends){
//        
//        self.contentView.footerView.hidden = true;
//        [self.contentView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.equalTo(@0);
//        }];
//    }
//    
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.isAddFriendsMode)
        [self setViewAlpha:kMinOpasity];
    
    if (self.isAddFriendsMode){
        
        self.contentView.footerView.hidden = true;
        [self.contentView.footerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@0);
        }];
        
        [self.contentView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView);
        }];
    } else {
        self.contentView.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    if (!self.isAddFriendsMode)
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self setViewAlpha:1];

    }];
    
    self.overleyNavBar.hidden = false;

}

- (NSAttributedString*)attributedStringWithString:(NSString*)string
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 4;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, string.length)];
    
    
    return attributedString;
    
}


- (void)showHiddenAnimationWithComplete:(void(^)())complete
{
    if (!self.isAddFriendsMode)
    [UIView animateWithDuration:kAnimationDuration animations:^{
        [self setViewAlpha:kMinOpasity];
        
    } completion:^(BOOL finished) {
        if (complete)
            complete();
    }];
    else
        if (complete)
            complete();
}

- (void)setViewAlpha:(CGFloat)alpha
{
    self.contentView.tableView.alpha = alpha;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
     self.contentView.tableView.tableHeaderView = [self header];
    
    self.contentView.layer.cornerRadius = 8;
    self.view.backgroundColor = [UIColor blackColor];
    
    @weakify(self);
    self.contentView.footerView.continueButton.enabled = true;
    [[self.contentView.footerView.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler continueSelected];
    }];
    
    [[self.contentView.footerView.skipButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler continueSelected];
    }];
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];

    
   
    
    self.overleyNavBar.hidden = self.isHideOverley;

    [self.contentView addSubview:self.overleyNavBar];
    
     self.overleyNavBar.layer.zPosition = 1;
    [self.contentView bringSubviewToFront:self.backButton];

}


- (UIImageView*)header {
    if (!_header) {
        
        _header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
        _header.image = [UIImage imageNamed:@"questionair-2"];
        _header.contentMode = UIViewContentModeScaleAspectFill;
        _header.clipsToBounds = YES;
        
        _titleLabel = [UILabel new];
        _titleLabel.textColor = [UIColor whiteColor];
        
        
        _titleLabel.textAlignment = NSTextAlignmentCenter;
//        _titleLabel.attributedText =  [self attributedStringWithString:FRLocalizedString(@"Here are some nearby users we \nthink you'll hit it off with", nil)];
        _titleLabel.text = FRLocalizedString(@"Here are some nearby users we \nthink you'll hit it off with", nil);
        _titleLabel.numberOfLines = 2;
        _titleLabel.adjustsFontSizeToFitWidth = true;
        
//        CGFloat size = [_titleLabel.text fontSizeWithFont:FONT_PROXIMA_NOVA_SEMIBOLD(21) constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 80, 4)];
        _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(21);
        
        [_header addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_header).offset(65);
            make.left.equalTo(_header).offset(40);
            make.right.equalTo(_header).offset(-40);
            
        }];

    }
    
    return _header;
}


#pragma mark - User Interface

- (void)updateDataSource:(FRRecommendedUsersDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (void)backSelected
{
    [self.eventHandler backSelected];
}

#pragma mark - FRTableController Delegate

#pragma mark - LazyLoad

- (FRRecommendedUsersContentView*)contentView
{
    if (!_contentView)
    {
        _contentView = [FRRecommendedUsersContentView new];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentView;
}

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
        [self.contentView addSubview:_backButton];
    }
    
    return _backButton;
}


@end
