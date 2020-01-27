//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsVC.h"
#import "FRAddInterestsController.h"
#import "FRAddInterestsDataSource.h"
#import "FRAddInterestsContentView.h"
#import "FRFooterQuestionairView.h"
#import "FRHeaderQuestionairView.h"
#import "NSString+SizeFit.h"

@interface FRAddInterestsVC () <FRAddInterestsContentViewDelegate, BSTableControllerScrollDelegate>

@property (nonatomic, strong) FRAddInterestsController* controller;
@property (nonatomic, strong) FRAddInterestsContentView* contentView;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, strong) UILabel* titleLabel;
@end

static CGFloat const kHeaderSectionHeight = 80;
static CGFloat const kAnimationDuration = 0.7;
static CGFloat const kMinOpasity = 0.15;

@implementation FRAddInterestsVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentView.delegate = self;
        self.controller = [[FRAddInterestsController alloc] initWithTableView:self.contentView.tableView];
        self.controller.interestsScrollDeletage = self;
        self.controller.scrollDelegate = self;
        self.statusBarBackgraundView.backgroundColor = [[UIColor bs_colorWithHexString:@"00B5FF"] colorWithAlphaComponent:0.6];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setViewAlpha:kMinOpasity];
    
    CGFloat size = [_titleLabel.text fontSizeWithFont:FONT_PROXIMA_NOVA_SEMIBOLD(21) constrainedToSize:_titleLabel.bounds.size];
    _titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(size);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    
    UIImageView* header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
    header.image = [UIImage imageNamed:@"questionair-1"];
    header.contentMode = UIViewContentModeScaleAspectFill;
    header.clipsToBounds = YES;
    
    _titleLabel = [UILabel new];
    _titleLabel.textColor = [UIColor whiteColor];

    
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.attributedText =  [self attributedStringWithString:FRLocalizedString(@"Add interests and get\n discovered by more users", nil)];
    _titleLabel.numberOfLines = 2;
    _titleLabel.adjustsFontSizeToFitWidth = true;
    [header addSubview:_titleLabel];
    
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header).offset(65);
        make.left.equalTo(header).offset(40);
        make.right.equalTo(header).offset(-40);

    }];
    
    
    
    
    self.contentView.tableView.tableHeaderView = header;
    [UIView animateWithDuration:kAnimationDuration animations:^{
       [self setViewAlpha:1];
        
    }];
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

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
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
    self.contentView.layer.cornerRadius = 8;
    self.view.backgroundColor = [UIColor blackColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enableContinue:) name:@"changeSelectedInterests" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollToTop:) name:@"searchBarClicked" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideKeyboard:) name:@"hideKeyboard" object:nil];

    [self attachKeyboardHelper];
    @weakify(self);
        [[self.contentView.footerView.continueButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.eventHandler continueSelected];
        }];
    self.overleyNavBar.hidden = self.isHideOverley;
    
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
    
    self.contentView.tableView.contentOffset = CGPointMake(0, 80);
    
    
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


- (void)enableContinue:(NSNotification*)notification {
    NSNumber* count = [notification object];
    
    self.contentView.footerView.continueButton.enabled = count.integerValue >= 3;
}

- (void)selectedContinue
{
    [self.eventHandler continueSelected];
}

- (void)scrollToTop:(NSNotification *)note
{
    return;
    
    self.contentView.tableView.contentOffset = CGPointMake(0, 200);
    CGRect keyboardBounds;
    
    NSDictionary *userInfo = note.object;
    [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardBounds];
    
    [self.contentView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(-keyboardBounds.size.height);
    }];
}

#pragma mark - BSTableControllerScrollDelegate

- (void)tableScrollViewDidScroll:(UIScrollView*)scrollView
{
    if (self.contentView.tableView.contentSize.height < self.screenHeight)
    {
        return;
    }
    
    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
    
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) >= scrollView.contentSize.height || scrollView.contentOffset.y <= 0)
    {
        return;
    }
    
    if (scrollView.contentOffset.y < kHeaderSectionHeight && (self.heightInset < 0))
    {
        self.heightInset += (self.lastOffsetY - scrollView.contentOffset.y);
        self.heightInset = self.heightInset > 0 ? 0 : self.heightInset;
        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset, 0, 0, 0);
    }
    
    else if (self.lastOffsetY < scrollView.contentOffset.y && (self.heightInset >= - sectionHeaderHeight))
    {
        self.heightInset -= (scrollView.contentOffset.y - self.lastOffsetY );
        self.heightInset = self.heightInset < -sectionHeaderHeight ? -sectionHeaderHeight : self.heightInset;
        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset+0.5, 0, 0, 0);
    }
        
    self.lastOffsetY = scrollView.contentOffset.y;
}

#pragma mark - LazyLoad

- (FRAddInterestsContentView*)contentView
{
    if (!_contentView)
    {
        _contentView = [FRAddInterestsContentView new];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentView;
}


#pragma mark - User Interface

- (void)updateDataSource:(FRAddInterestsDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


#pragma mark - FRTableController Delegate

#pragma mark - FRAddInterestsContentViewDelegate

- (void)addTag:(NSString*)tag
{
    [self.eventHandler addTagSelected:tag];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)hideKeyboard:(NSNotification*)notification
{
    self.contentView.tableView.contentOffset = CGPointMake(0, 0);
    
    [_contentView.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView).offset(-50);
    }];
}

@end
