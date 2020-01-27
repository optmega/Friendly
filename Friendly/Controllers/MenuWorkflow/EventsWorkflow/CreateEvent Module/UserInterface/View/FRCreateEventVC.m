//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventVC.h"
#import "FRCreateEventController.h"
#import "FRCreateEventDataSource.h"
#import "UIScrollView+EKKeyboardAvoiding.h"
#import "DAKeyboardControl.h"
#import "FRGlobalHeader.h"
#import "FRStyleKit.h"
#import "CMPopTipView.h"
#import "FRSettingsTransport.h"
#import "FRCreateEventPartnerHostingCell.h"

@interface FRCreateEventVC () <FRCreateEventControllerDelegate>

@property (nonatomic, strong) FRCreateEventController* controller;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* createButton;
@property (nonatomic, assign) FRCreateEventType type;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* saveButton;
@property (nonatomic, strong) UIImageView* backgroundStatusBar;
@property (nonatomic, strong) UIImageView* downCurves;
@property (nonatomic, strong) UIView* createView;
@property (nonatomic, strong) CMPopTipView* tooltipView;


@end


@implementation FRCreateEventVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRCreateEventController alloc] initWithTableView:self.tableView];
        self.controller.delegate = self;
        self.controller.scrollDelegate = self;
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"CreateEventScreen"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self backgroundStatusBar];
    [self downCurves];
    [self.tableView addSubview:self.overleyNavBar];
    self.createButton.enabled = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButton:) name:@"canCreateEvent" object:nil];
    @weakify(self);
    [[self.createButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        self.createButton.enabled = false;
        if (self.type == FRCreateEventCreate)
        {
            [self.eventHandler createEventSelected];
        } else if (self.type == FRCreateEventEdit)
        {
            [self.eventHandler deleteEvent];
        }
    }];
    
    [[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    [[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler updateEventSelected];
    }];
    
    [self.view bringSubviewToFront:self.backButton];
    self.backButton.alpha = 1;
    
    self.overleyNavBar.hidden = false;
    self.backButton.layer.zPosition += 10;
    self.saveButton.layer.zPosition += 10;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createEventHelperView" object:nil];

}

- (void)keyboardWillAppear:(id)sender
{
}

- (void)keyboardWillDisappear:(id)sender
{
}

- (void)changePositionY:(CGFloat)y
{
    [super changePositionY:y];
    
    CGRect backStatusFrame = self.backgroundStatusBar.frame;
    backStatusFrame.origin.y =  y;
    self.backgroundStatusBar.frame = backStatusFrame;
    
    CGRect backButtonFrame = self.backButton.frame;
    backButtonFrame.origin.y = 30 + y;
    self.backButton.frame = backButtonFrame;
    
    CGRect saveButtonFrame = self.saveButton.frame;
    saveButtonFrame.origin.y = 30 + y;
    self.saveButton.frame = saveButtonFrame;
    
}

-(void)updateButton:(NSNotification*)notification
{
    NSDictionary* userInfo = notification.userInfo;
    NSString* total = (NSString*)userInfo[@"isAvailable"];
    if ([total isEqualToString:@"1"])
    {
        self.createButton.enabled = YES;
    }
    else
    {
        self.createButton.enabled = NO;
    }
}

#pragma mark - User Interface

- (void)updateDataSource:(FRCreateEventDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (void)updateWithType:(FRCreateEventType)type
{
    self.type = type;
    
    switch (type) {
        case FRCreateEventCreate:
        {
            _createButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
            _createButton.enabled = NO;
            [_createButton setTitle:FRLocalizedString(@"Create event", nil) forState:UIControlStateNormal];
            [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_createButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            self.saveButton.hidden = YES;
            self.downCurves.hidden = YES;
            self.backgroundStatusBar.hidden = YES;
        } break;
            
        case FRCreateEventEdit:
        {
            _createButton.backgroundColor = [UIColor whiteColor];
            _createButton.enabled = YES;
            [_createButton setTitle:FRLocalizedString(@"Delete event", nil) forState:UIControlStateNormal];
            [_createButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            [_createButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            _createButton.hidden = YES;
            self.saveButton.hidden = NO;
            self.backgroundStatusBar.hidden = NO;
            self.downCurves.hidden = NO;
            [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.right.bottom.equalTo(self.view);
            }];

        } break;
            
        default:
            break;
    }
}


- (BOOL)prefersStatusBarHidden {
    return NO;
}


#pragma mark - FRTableController Delegate

- (UIButton*)backButton
{
    if (!_backButton)
    {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 30, 35, 35)];
        [_backButton setImage:[FRStyleKit imageOfNavCloseCanvas] forState:UIControlStateNormal];
        _backButton.imageEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
        _backButton.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.6];
        _backButton.layer.cornerRadius = 17.5;
        [self.tableView addSubview:_backButton];
        
    }
    return _backButton;
}

- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [_tableView setSeparatorColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.bounces = NO;
        _tableView.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        _tableView.autoresizesSubviews = YES;
        [_tableView setKeyboardAvoidingEnabled:YES];
        [self.view addSubview:_tableView];
        
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.bottom.equalTo(self.createButton.mas_top);
        }];
    }
    return _tableView;
}

- (UIButton*)createButton
{
    if (!_createButton)
    {
        _createButton = [UIButton new];
        _createButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_createButton setTitle:FRLocalizedString(@"Create event", nil) forState:UIControlStateNormal];
        [_createButton setTitle:FRLocalizedString(@"Fill in all required", nil) forState:UIControlStateDisabled];
        [_createButton setBackgroundImage:[UIImage imageNamed:@"939db6"] forState:UIControlStateDisabled];
        [_createButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_createButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [_createButton setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.4] forState:UIControlStateDisabled];
        
        _createButton.titleLabel.font = FONT_SF_DISPLAY_SEMIBOLD(16);
        [self.view addSubview:_createButton];
        
        [_createButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    return _createButton;
}

- (UIButton*)saveButton
{
    if (!_saveButton)
    {
        CGFloat x = [UIScreen mainScreen].bounds.size.width - 50;
        
        _saveButton = [[UIButton alloc] initWithFrame:CGRectMake(x, 30, 35, 35)];
        [_saveButton setImage:[FRStyleKit imageOfEditProfileTick] forState:UIControlStateNormal];
        _saveButton.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _saveButton.layer.cornerRadius = 17.5;
        _saveButton.hidden = YES;
        [self.tableView addSubview:_saveButton];
    }
    return _saveButton;
}

-(UIImageView*)backgroundStatusBar
{
    if (!_backgroundStatusBar)
    {
        _backgroundStatusBar = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 14)];
        [_backgroundStatusBar setImage:[FRStyleKit imageOfGroup4Canvas2]];
//        [_backgroundStatusBar setImage:[UIImage imageNamed:@"above-statusbar.png"]];
        _backgroundStatusBar.contentMode = UIViewContentModeScaleToFill;
        [self.tableView addSubview:_backgroundStatusBar];
////        [self.backButton bringSubviewToFront:_backgroundStatusBar];
//        [_backgroundStatusBar mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.left.right.equalTo(self.tableView);
//            make.height.equalTo(@30);
//        }];
    }
    return _backgroundStatusBar;
}

-(UIImageView*)downCurves
{
    if (!_downCurves)
    {
        _downCurves = [UIImageView new];
        [_downCurves setImage:[FRStyleKit imageOfGroup4CopyCanvas]];
        //        [_backgroundStatusBar setImage:[UIImage imageNamed:@"above-statusbar.png"]];
        _downCurves.contentMode = UIViewContentModeScaleToFill;
        _downCurves.layer.zPosition = 10;
        [self.view addSubview:_downCurves];
        //        [self.backButton bringSubviewToFront:_backgroundStatusBar];
                [_downCurves mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.bottom.left.right.equalTo(self.view);
                    make.height.equalTo(@14);
                }];
    }
    return _downCurves;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    
    setStatusBarColor([UIColor whiteColor]);
    return UIStatusBarStyleLightContent;
}



#pragma mark - FRCreateEventControllerDelegate

- (void)selectedCell:(FRCreateEventCellType)cellType
{
    
    [self.view endEditing:YES];
    
    BSDispatchBlockAfter(0.1,^{
        
        switch (cellType) {
            case FRCreateEventCellTypeCategory:
            {
                [self.eventHandler categorySelected];
            } break;
            case FRCreateEventCellTypePartnerHosting:
            {
                FRCreateEventPartnerHostingCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:FRCreateEventCellTypePartnerHosting inSection:0]];
                [cell.searchHelperView dismissAnimated:true];
                [[NSUserDefaults standardUserDefaults] setObject:@"hide" forKey:@"CohostPopView"];
                
                [self.eventHandler partnerHostingSelectedWith:self.eventId];
            } break;
            case FRCreateEventCellTypeInviteFriends:
            {
                [self.eventHandler inviteFriendsSelectedWith:self.eventId];
            } break;
                
            case FRCreateEventCellTypeAges:
            {
                [self.eventHandler agesSelected];
            } break;
                
            case FRCreateEventCellTypeGender:
            {
                [self.eventHandler genderSelected];
            } break;
                
            case FRCreateEventCellTypeOpenSlots:
            {
                [self.eventHandler openSlotsSelected];
            } break;
                
            case FRCreateEventCellTypeTime:
            {
                [self.eventHandler timeSelected];
            } break;
                
            case FRCreateEventCellTypeDate:
            {
                [self.eventHandler dateSelected];
            } break;
                
            case FRCreateEventCellTypeLocation:
            {
                [self.eventHandler locationSelected];
            } break;
                
            default:
                break;
        }
    });
    
}





@end
