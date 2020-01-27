//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREditProfileVC.h"
#import "FREditProfileController.h"
#import "FREditProfileDataSource.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FREditProfileVC ()

@property (nonatomic, strong) FREditProfileController* controller;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* saveButton;
@property (nonatomic, strong) UIImageView* overlayWallImage;
@property (nonatomic, strong) UIImageView* wallImage;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, strong) UIButton* backButton;


@end


@implementation FREditProfileVC



- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FREditProfileController alloc] initWithTableView:self.tableView];
        self.controller.scrollDelegate = self;
    }
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self attachKeyboardHelper];
    [self.view setBackgroundColor:[UIColor whiteColor]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"EditProfileScreen"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self detachKeyboardHelper];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
  
    
    @weakify(self);
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.view endEditing:YES];
        [self.eventHandler saveSelected];
    }];

    [self backButton];
    [self.backButton addTarget:self action:@selector(cancelEdit) forControlEvents:UIControlEventTouchUpInside];
    [self wallImage];
    [self overlayWallImage];
    [self.view bringSubviewToFront:self.tableView];
    
    [self.overleyNavBar removeFromSuperview];
    self.overleyNavBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64)];
    self.overleyNavBar.image = [UIImage imageNamed:@"Offline Copy"];
    
    [self.tableView addSubview:self.overleyNavBar];
    
    
    [self.tableView addSubview:self.overleyNavBar];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 60)];
    


    self.backButton.layer.zPosition += 10;
    self.saveButton.layer.zPosition +=10;
}



- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

- (void)cancelEdit
{
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)updateWallImageUrl:(NSString*)imageUrl
{
    self.wallImage.image = [FRStyleKit imageOfArtboard121Canvas];
    
    [self.wallImage sd_setImageWithURL:[NSURL URLWithString:[NSObject bs_safeString:imageUrl]] placeholderImage:[FRStyleKit imageOfArtboard121Canvas]];
}

- (void)updateWallImage:(UIImage*)image
{
    self.wallImage.contentMode = UIViewContentModeScaleToFill;
    self.wallImage.image = image;
}

- (UIImageView*)wallImage
{
    if (!_wallImage)
    {
        _wallImage = [UIImageView new];
        _wallImage.image = [UIImage imageNamed:@"Questionair - header"];
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
    
    CGRect overleyFrame = self.overleyNavBar.frame;
    overleyFrame.origin.y = y;
    
    self.overleyNavBar.frame = overleyFrame;
    
    CGRect backButtonFrame = self.saveButton.frame;
    backButtonFrame.origin.y = 30 + y;
    self.saveButton.frame = backButtonFrame;
    
    CGRect cancelButtonFrame = self.backButton.frame;
    cancelButtonFrame.origin.y = 30+y;
    self.backButton.frame = cancelButtonFrame;

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
//    [self.view endEditing:YES];
    
}

//
//- (void)attachKeyboardHelper{
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillAppear:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}
//
//- (void)detachKeyboardHelper{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}
//
//- (void)keyboardWillAppear:(NSNotification *)notification{
//    
//    CGRect keyboardEndFrame;
//    [[[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardEndFrame];
//    
//    CGRect keyboardFrame = [self.view convertRect:keyboardEndFrame toView:nil];
//
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-keyboardFrame.size.height);
//    }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)notification{
//    
//    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.bottom.equalTo(self.view);
//    }];
//}

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
    
    
    
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-keyboardFrame.size.height);
    }];
    
    
    
    //    [self.contentView layoutIfNeeded];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-50);
    }];
    
    //    [self.contentView layoutIfNeeded];
}


-(void)tableTapped
{
    [self.view endEditing:YES];
}

#pragma mark - User Interface

- (void)updateDataSource:(FREditProfileDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


#pragma mark - FRTableController Delegate

#pragma mark - Lazy Load

- (UIButton*)saveButton
{
    if (!_saveButton)
    {
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 50;
        
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 30, 35, 35)];
        _saveButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
//        [_saveButton setTitle:FRLocalizedString(@"Save", nil) forState:UIControlStateNormal];
//        _saveButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        [_saveButton setImage:[FRStyleKit imageOfEditProfileTick] forState:UIControlStateNormal];
        _saveButton.layer.masksToBounds = NO;
//        _saveButton.layer.zPosition = 5;
        _saveButton.layer.cornerRadius = 17.5;
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.tableView addSubview:_saveButton];
//        [self.view insertSubview:_saveButton aboveSubview:[self.view.subviews lastObject]];

    }
    return _saveButton;
}


- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tableTapped)];
        [_tableView addGestureRecognizer:tap];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.showsVerticalScrollIndicator = NO;
//        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
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
        _backButton.backgroundColor = [[UIColor bs_colorWithHexString:@"030406"] colorWithAlphaComponent:0.8];
        _backButton.layer.cornerRadius = 17.5;
//        _backButton.layer.zPosition = 5;
        [_backButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        [self.tableView addSubview:_backButton];
        
//        [self.view insertSubview:_backButton aboveSubview:[self.view.subviews lastObject]];
        
        
    }
    return _backButton  ;
}

@end
