//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileVC.h"
#import "FRUserProfileController.h"
#import "FRUserProfileDataSource.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"

@interface FRUserProfileVC ()

@property (nonatomic, strong) FRUserProfileController* controller;
//@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* messageButton;
@property (nonatomic, strong) UIImageView* overlayWallImage;
@property (nonatomic, strong) UIImageView* wallImage;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

@end


@implementation FRUserProfileVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        UIView* background = [UIView new];
        [self.view addSubview:background];
        background.backgroundColor = [UIColor whiteColor];
        [background mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
        background.layer.zPosition = -1;
        
        [self.view setBackgroundColor:[UIColor whiteColor]];
        self.controller = [[FRUserProfileController alloc] initWithTableView:self.tableView];
        self.controller.scrollDelegate = self;
        [self setNeedsStatusBarAppearanceUpdate];
        [self.view bringSubviewToFront:self.tableView];
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"UserProfileScreen"];
    [self.view setBackgroundColor:[UIColor whiteColor]];    
     setStatusBarColor([UIColor whiteColor]);
}

- (void)updateWithPrivateAccount:(BOOL)isPrivateAccount {
    self.messageButton.hidden = isPrivateAccount;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.overleyNavBar];

    @weakify(self);
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    [[self.messageButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler messageSelected];
    }];
    
    [self wallImage];
    [self overlayWallImage];
    [self.view bringSubviewToFront:self.tableView];

    self.overleyNavBar.hidden = false;
    self.messageButton.layer.zPosition += 10;
    self.backButton.layer.zPosition += 10;
    [self setNeedsStatusBarAppearanceUpdate];
    
    setStatusBarColor([UIColor whiteColor]);
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
        [self setNeedsStatusBarAppearanceUpdate];

}

- (void)updateWallImage:(NSString *)imageUrl
{
    self.wallImage.image = [FRStyleKit imageOfArtboard121Canvas];
    
    [self.wallImage sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:imageUrl]] placeholderImage:[FRStyleKit imageOfArtboard121Canvas]];
    
}

- (UIImageView*)wallImage
{
    if (!_wallImage)
    {
        _wallImage = [UIImageView new];
        _wallImage.image = [FRStyleKit imageOfArtboard121Canvas];
        [self.view addSubview:_wallImage];
        [_wallImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.centerX.equalTo(self.view);
            self.width = [UIScreen mainScreen].bounds.size.width;
            make.width.equalTo(@(self.width));
            self.height = [UIScreen mainScreen].bounds.size.width / 1.6;
            make.height.equalTo(@(self.height));
            
        }];
    }
    return _wallImage;
}


-(UIImageView*)overlayWallImage
{
    if (!_overlayWallImage)
    {
        _overlayWallImage = [UIImageView new];
        _overlayWallImage.contentMode = UIViewContentModeScaleToFill;
        [_overlayWallImage setImage:[UIImage imageNamed:@"Gradient overlay"]];
        [self.wallImage addSubview:_overlayWallImage];
        [_overlayWallImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.wallImage);
        }];
    }
    return _overlayWallImage;
}

- (void)changePositionY:(CGFloat)y
{
    [super changePositionY:y];
    CGRect backButtonFrame = self.backButton.frame;
    backButtonFrame.origin.y = 50 + y;
    self.backButton.frame = backButtonFrame;
    
    CGRect messageButtonFrame = self.messageButton.frame;
    messageButtonFrame.origin.y = 50 + y;
    self.messageButton.frame = messageButtonFrame;
    
    
    if (y >= 0) {
        [self.wallImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.height));
            make.width.equalTo(@(self.width));
        }];
    } else {
        [self.wallImage mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@(self.height + (- y / 1.41)));
            make.width.equalTo(@(self.width + (- y / 1.11)));
        }];
    }

}

#pragma mark - User Interface

- (void)updateDataSource:(FRUserProfileDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

#pragma mark - FRTableController Delegate


#pragma mark - Lazy Load

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
//        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];

        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.view);
            make.top.equalTo(self.view).offset(-20);
        }];
    }
    return _tableView;
}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 50, 35, 35)];
        _backButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.6];
        _backButton.layer.cornerRadius = 17.5;
        [_backButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        [self.tableView addSubview:_backButton];
        
    }
    return _backButton  ;
}



- (UIButton*)messageButton
{
    if (!_messageButton)
    {
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 55;
                
        _messageButton = [[UIButton alloc]initWithFrame:CGRectMake(x, 50, 35, 35)];
        _messageButton.layer.masksToBounds = NO;
        _messageButton.layer.zPosition = 5;

        _messageButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.6];
        [_messageButton setImage:[FRStyleKit imageOfNavChatCanvas] forState:UIControlStateNormal];
        _messageButton.layer.cornerRadius = 17.5;
        [_messageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_messageButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.tableView addSubview:_messageButton];
        
    }
    return _messageButton;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}



@end
