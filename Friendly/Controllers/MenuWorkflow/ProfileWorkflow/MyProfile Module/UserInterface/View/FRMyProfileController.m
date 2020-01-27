//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileController.h"
#import "FRMyProfileDataSource.h"

#import "FRMyProfileUserPhotoCell.h"
#import "FRMyProfileViewConstants.h"
#import "FRMyProfileIconCell.h"
#import "FRMyProfileShareInstagramCell.h"
#import "FRMyProfileUserBioCell.h"
#import "FRMyProfileWhyAreYouCell.h"

#import "FRMyProfileInterestsCell.h"
#import "FRPhotosMutualFriendCell.h"
#import "FRUserProfileHeaderCellViewModel.h"

@interface FRMyProfileController ()


@end

@implementation FRMyProfileController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRMyProfileUserPhotoCell class] forModelClass:[FRMyProfileUserPhotoCellViewModel class]];
        [self registerCellClass:[FRMyProfileIconCell class] forModelClass:[FRMyProfileIconCellViewModel class]];
        [self registerCellClass:[FRMyProfileShareInstagramCell class] forModelClass:[FRProfileShareInstagramCellViewModel class]];
        [self registerCellClass:[FRMyProfileUserBioCell class] forModelClass:[FRMyProfileUserBioCellViewModel class]];
        [self registerCellClass:[FRMyProfileWhyAreYouCell class] forModelClass:[FRMyProfileWhyAreYouCellViewModel class]];
        
        [self registerCellClass:[FRPhotosMutualFriendCell class] forModelClass:[FRPhotosMutualFriendCellViewModel class]];
        [self registerCellClass:[FRMyProfileInterestsCell class] forModelClass:[FRMyProfileInterestsCellViewModel class]];
        
    }
    return self;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3) {
        FRMyProfileIconCellViewModel* model = [(BSMemoryStorage*)self.storage itemAtIndexPath:indexPath];
        [model presentAddMobileController];
    }
    if (indexPath.row == 2)
    {
        FRMyProfileIconCellViewModel* model = [(BSMemoryStorage*)self.storage itemAtIndexPath:indexPath];
        [model presentInviteFriendsController];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDataSource:(FRMyProfileDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    
    switch (indexPath.row) {
        case FRMyProfileCellTypeUserPhoto:
        {
            
            FRUserProfileHeaderCellViewModel* model = [storage itemAtIndexPath:indexPath];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)];
            label.text = model.profession;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
            
            
            
            return 280 + label.bounds.size.height;
        } break;
            case FRMYProfileCellTypeAvailable:
        {
            return 70;
        } break;
        case FRMyProfileCellTypeInviteYourFriends:
        {
             return 70;
        } break;
        case FRMyProfileCellTypeMobile:
        {
            return 70;
        } break;
        case FRMyProfileCellTypeShareInstagram:
        {
            FRProfileShareInstagramCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return model.heightCell;
        } break;
        case FRMyProfileCellTypeYourBio:
        {
            FRMyProfileUserBioCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return model.heightCell;
        } break;
            
        case FRMyProfileCellTypeWhyAreYouHere:
        {
            FRMyProfileWhyAreYouCellViewModel* model = [storage itemAtIndexPath:indexPath];
            
            return model.cellHeight;
        } break;
        case FRUserProfileCellTypeFriends:
        {
            FRPhotosMutualFriendCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return [model height];
//            return 220;
        }
        case FRMyProfileCellTypeInterests:
        {
            FRMyProfileInterestsCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return  [model height] + 75;
        } break;
      
            
        default:
            return self.tableView.rowHeight;
            break;
    }
}

@end

