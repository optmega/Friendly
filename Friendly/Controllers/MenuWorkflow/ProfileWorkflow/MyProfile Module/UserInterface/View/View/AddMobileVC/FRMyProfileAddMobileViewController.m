//
//  FRMyProfileAddMobileViewController.m
//  Friendly
//
//  Created by User on 23.09.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileAddMobileViewController.h"
#import "FRMyProfileAddMobileIconCell.h"
#import "FRMyProfileAddMobileAddNumberCell.h"
#import "FRSettingsTransport.h"
#import "FRProfileDomainModel.h"
#import "BSHudHelper.h"

@interface FRMyProfileAddMobileViewController () <UITableViewDelegate, UITableViewDataSource,FRMyProfileAddMobileAddNumberCellDelegate>

@property (strong, nonatomic) UITableView* tableView;

@end

@implementation FRMyProfileAddMobileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Add mobile";
    [self tableView];
    [self.view setBackgroundColor:[UIColor bs_colorWithHexString:@"#E8EBF1"]];
}

- (void)viewDidAppear:(BOOL)animated
{
    FRMyProfileAddMobileAddNumberCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    [cell.textField becomeFirstResponder];

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    [self setStatusBarColor:[UIColor blackColor]];
    return UIStatusBarStyleDefault;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* returnCell = [UITableViewCell new];
    if (indexPath.row == 0)
    {
        FRMyProfileAddMobileIconCell* cell = [FRMyProfileAddMobileIconCell new];
        returnCell = cell;
    }
    else
    {
        FRMyProfileAddMobileAddNumberCell* cell = [FRMyProfileAddMobileAddNumberCell new];
        if ([FRUserManager sharedInstance].currentUser.mobileNumber)
        {
            cell.textField.text = [FRUserManager sharedInstance].currentUser.mobileNumber;
        }
        cell.delegate = self;
        returnCell = cell;
    }
    returnCell.selectionStyle = UITableViewCellSeparatorStyleNone;
    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 90;
    }
    else
    {
        return 140;
    }
}

- (void)addNumber:(NSString *)number
{
    [self.tableView endEditing:YES];
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    FRProfileDomainModel* model = [FRProfileDomainModel new];
    model.mobile_number = number;
    [FRSettingsTransport updateProfile:model success:^{
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
//        UIAlertController* alertController = [UIAlertController alertControllerWithTitle:FRLocalizedString(@"Success!", nil) message:FRLocalizedString(@"Number updated", nil) preferredStyle:UIAlertControllerStyleAlert];
//        
//        
//        UIAlertAction* accept = [UIAlertAction actionWithTitle:FRLocalizedString(@"OK", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            
//            
//        }];
//        
//        [alertController addAction:accept];
//        [self presentViewController:alertController animated:true completion:nil];

    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:@"Error" message:error.localizedDescription];
    }];
    
}


#pragma mark - LazyLoad
    
- (UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [UITableView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom).offset(15);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@240);
        }];
    }
    return _tableView;
}

-(void)setStatusBarColor:(UIColor*)color
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
        
        [statusBar performSelector:setForegroundColor_sel withObject:color];
    }
    else
    {
        return;
    }
}


@end


