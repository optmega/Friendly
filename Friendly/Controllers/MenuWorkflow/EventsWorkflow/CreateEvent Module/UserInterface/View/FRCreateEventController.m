//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventController.h"
#import "FRCreateEventDataSource.h"

#import "FRCreateEventAddImageCell.h"
#import "FRCreateEventTextViewCell.h"
#import "FRCreateEventAgeCell.h"
#import "FRCreateEventPartnerHostingCell.h"
#import "FRCreateEventOpenToFBCell.h"
#import "FRCreateEventInviteCell.h"
#import "FRCreateEventInformationCell.h"
#import "FRCreateEventIconDataCell.h"
#import "FRCreateEventCreateActionCell.h"
#import "FRCreateEventShowNumberCell.h"
#import "FRCreateEventInviteCell.h"
#import "FREventPreviewAttendingViewModel.h"
#import "FREventPreviewAttendingCell.h"

@interface FRCreateEventController () <FRCreateEventTextViewCellDelegate>

@end

@implementation FRCreateEventController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRCreateEventAddImageCell class] forModelClass:[FRCreateEventAddImageCellViewModel class]];
        [self registerCellClass:[FRCreateEventTextViewCell class] forModelClass:[FRCreateEventTextViewCellViewModel class]];
        [self registerCellClass:[FRCreateEventAgeCell class] forModelClass:[FRCreateEventAgeCellViewModel class]];
        [self registerCellClass:[FRCreateEventPartnerHostingCell class] forModelClass:[FRCreateEventPartnerHostingCellViewModel class]];
        [self registerCellClass:[FRCreateEventOpenToFBCell class] forModelClass:[FRCreateEventOpenToFBCellViewModel class]];
        [self registerCellClass:[FRCreateEventInviteCell class] forModelClass:[FRCreateEventInviteCellViewModel class]];
        [self registerCellClass:[FRCreateEventInformationCell class] forModelClass:[FRCreateEventInformationCellViewModel class]];
        [self registerCellClass:[FRCreateEventIconDataCell class] forModelClass:[FRCreateEventIconDataCellViewModel class]];
        [self registerCellClass:[FRCreateEventCreateActionCell class] forModelClass:[FRCreateEventCreateActionCellViewModel class]];
        [self registerCellClass:[FRCreateEventShowNumberCell class] forModelClass:[FRCreateEventShowNumberCellViewModel class]];
        [self registerCellClass:[FRCreateEventInviteCell class] forModelClass:[FRCreateEventInviteCellViewModel class]];
        [self registerCellClass:[FREventPreviewAttendingCell class] forModelClass:[FREventPreviewAttendingViewModel class]];
        
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.delegate selectedCell:indexPath.row];
}

- (void)updateDataSource:(FRCreateEventDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (void)textEditing:(UITableViewCell*)cell
{
    NSIndexPath* indexPath = [self.tableView indexPathForCell:cell];
    
    [self.tableView beginUpdates];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
    CGPoint point = self.tableView.contentOffset;
//    if (point.y < 310)
//    {
//        
//        point.y -= 30;
//    }
//    else
//    {
//        point.y -= 70;
//    }
    self.tableView.contentOffset = point;
    [self.tableView endUpdates];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == FRCreateEventCellTypeTitle || indexPath.row == FRCreateEventCellTypeDescription)
    {
        FRCreateEventTextViewCell* textViewCell = (id)cell;
        textViewCell.delegate = self;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    switch (indexPath.row) {
        case FRCreateEventCellTypePhoto:
        {
            return 300;
        } break;
        case FRCreateEventCellTypeTitle:
        {
            return 100;
        } break;
        case FRCreateEventCellTypeDescription:
        {
            return 100;

        } break;
        case FRCreateEventCellTypeGender:
        {
            return 51.5;

        } break;
        case FRCreateEventCellTypeAges:
        {
            return 51.5;

        } break;
        case FRCreateEventCellTypeOpenSlots:
        {
            return 51.5;

        } break;
        case FRCreateEventCellTypeCategory:
        {
            return 51.5;

        } break;
        case FRCreateEventCellTypeInviteFriends:
        {
            return 51.5;
        } break;
        case FRCreateEventCellTypePartnerHosting:
        {
            return 87;

        } break;
        case FRCreateEventCellTypeOpenToFacebookFriends:
        {
            return 87;

        } break;
        case FRCreateEventCellTypeEventInformation:
        {
            return 110;

        } break;
        case FRCreateEventCellTypeDate:
        {
            return 51.5;
        } break;
        case FRCreateEventCellTypeLocation:
        {
            return 51.5;
        } break;
        case FRCreateEventCellTypeTime:
        {
            return 51.5;
        } break;
        case FRCreateEventCellTypeShowNumber:
        {
            return 0; //87

        } break;
        case FRCreateEventCellTypeInvite:
        {
            
//            FRCreateEventInviteCellViewModel* model = [storage itemAtIndexPath:[NSIndexPath indexPathForRow:17 inSection:0]];
            if (17 == [storage.storageArray count])
            {
                return 225;
            }
            
            return 245;

        } break;
        case FRCreateEventCellTypeCreateEventAction:
        {
            BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
          if (17 == [storage.storageArray count])
          {
              return 275;
          }
            
            return 245;
        } break;
            
        default:
            return self.tableView.rowHeight;
            break;
    }
}
@end
