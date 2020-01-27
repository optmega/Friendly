//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingController.h"
#import "FRSettingDataSource.h"
#import "FRPrivateAccountCell.h"
#import "FRSettingViewConstants.h"
#import "FRTitleGroupCell.h"
#import "FRSupportCell.h"
#import "FRLogOutCell.h"
#import "FRDisplayNameCell.h"

static CGFloat const kTitleCelHeight = 40;

@implementation FRSettingController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRPrivateAccountCell class] forModelClass:[FRPrivateAccountCellViewModel class]];
        [self registerCellClass:[FRTitleGroupCell class] forModelClass:[NSString class]];
        [self registerCellClass:[FRSupportCell class] forModelClass:[FRSupportCellViewModel class]];
        [self registerCellClass:[FRLogOutCell class] forModelClass:[FRLogOutCellViewModel class]];
        [self registerCellClass:[FRDisplayNameCell class] forModelClass:[FRDisplayNameCellViewModel class]];
        self.tableView.rowHeight = 80;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == FRSettingCellTypeSupport) {
        NSString *recipients = @"mailto:support@joinfriendly.com";
        
        NSString *body = @"";
        
        NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
        
        email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
    }
    if (indexPath.row == FRSettingCellTypeLogOut)
    {
        [self.delegate logOut];
    }
}

- (void)updateDataSource:(FRSettingDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case FRSettingCellTypeNotificationTitle:
        {
            return kTitleCelHeight;
        } break;
        case FRSettingCellTypeEventRequests:
        {
            return self.tableView.rowHeight;
        } break;
        case FRSettingCellTypeFriendRequests:
        {
            return self.tableView.rowHeight;
        } break;
        case FRSettingCellTypeEventInvites:
        {
            return self.tableView.rowHeight;
        } break;
        case FRSettingCellTypeGroupChatMessages:
        {
            return self.tableView.rowHeight;
        } break;
        case FRSettingCellTypeAccountTitle:
        {
            return kTitleCelHeight;
        } break;
        case FRSettingCellTypePrivateAccount:
        {
            return 0;
        } break;
        case FRSettingCellTypeDisplayName:
        {
            return 0;
        } break;
        case FRSettingCellTypeSupport:
        {
            return self.tableView.rowHeight;
        } break;
        case FRSettingCellTypeLogOut:
        {
           return self.tableView.rowHeight;
        } break;
            
        default:
            return self.tableView.rowHeight;
            break;
    }
}

@end
