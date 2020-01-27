//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileVC.h"
#import "FRMyProfileController.h"
#import "FRMyProfileDataSource.h"
#import "FRStyleKit.h"
#import "UIImageView+WebCache.h"

@interface FRMyProfileVC ()

@property (nonatomic, strong) FRMyProfileController* controller;
@property (nonatomic, assign) BOOL isFirst;
@property (nonatomic, strong) UIButton* editButton;
@property (nonatomic, strong) UIImageView* wallImage;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIImageView* overlayWallImage;

@end


@implementation FRMyProfileVC

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
        self.controller = [[FRMyProfileController alloc] initWithTableView:self.tableView];
        self.controller.scrollDelegate = self;
        self.view.backgroundColor = [UIColor whiteColor];
        
        [self.view bringSubviewToFront:self.tableView];
        
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView addSubview:self.overleyNavBar];
    self.view.backgroundColor = [UIColor whiteColor];
    self.isFirst = YES;
    @weakify(self);
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    [[self.editButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler saveEditSelected];
    }];
    [self wallImage];
  //  [self.eventHandler updateData];
    [self.view bringSubviewToFront:self.tableView];
    [self overlayWallImage];
//    [self setNeedsStatusBarAppearanceUpdate];
    self.overleyNavBar.hidden = false;
    self.editButton.layer.zPosition += 10;
}

- (void)updateWallImage:(NSString*)imageUrl
{
    BSDispatchBlockToMainQueue(^{
        
        self.wallImage.image = [FRStyleKit imageOfArtboard121Canvas];
        [self.wallImage sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:imageUrl]] placeholderImage:[FRStyleKit imageOfArtboard121Canvas]];
    });
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

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  //  [self.eventHandler updateData];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    if (self.canUpdate){
         [self.eventHandler loadData];
    } else {
        self.canUpdate = true;
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.tableView reloadData];
    
    [APP_DELEGATE sendToGAScreen:@"MyProfileScreen"];
    
    if (self.isFirst)
    {
        self.isFirst = NO;
        return;
    }
    
    
   // [self.eventHandler updateData];
}

- (void)changePositionY:(CGFloat)y
{
    [super changePositionY:y];
    CGRect backButtonFrame = self.backButton.frame;
    backButtonFrame.origin.y = 30 + y;
    self.backButton.frame = backButtonFrame;
    
    CGRect editFrame = self.editButton.frame;
    editFrame.origin.y = 30 + y;
    self.editButton.frame = editFrame;
    
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

- (void)updateDataSource:(FRMyProfileDataSource *)dataSource
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
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        _tableView.contentInset = UIEdgeInsetsMake(-0, 0, 0, 0);
//        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 35, 35)];
        _backButton.layer.zPosition = 5;
        _backButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.6];
        _backButton.layer.cornerRadius = 17.5;
        [_backButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
        [self.tableView addSubview:_backButton];
        
    }
    return _backButton  ;
}

- (UIButton*)editButton
{
    if (!_editButton)
    {
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 50;
        
        _editButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 30, 35, 35)];
        _editButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
//        [_editButton setTitle:FRLocalizedString(@"Edit info", nil) forState:UIControlStateNormal];
        [_editButton setImage:[FRStyleKit imageOfEditCanvas] forState:UIControlStateNormal];
        _editButton.layer.zPosition = 5;

        _editButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _editButton.layer.cornerRadius = 17.5;
//        [_editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [_editButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.tableView addSubview:_editButton];
    }
    return _editButton;
}

- (void)dealloc {
    
}


@end
