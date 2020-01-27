//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileController.h"
#import "FRUserProfileDataSource.h"
#import "FRUserProfileViewConstants.h"

#import "FRMyProfileUserBioCell.h"
#import "FRMyProfileWhyAreYouCell.h"
#import "FRMyProfileInterestsCell.h"
#import "FRUserProfileHeaderCell.h"
#import "FRUserProfileInstagramPhotosCell.h"
#import "FRPhotosMutualFriendCell.h"


@implementation FRUserProfileController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRUserProfileHeaderCell class] forModelClass:[FRUserProfileHeaderCellViewModel class]];
        [self registerCellClass:[FRMyProfileUserBioCell class] forModelClass:[FRMyProfileUserBioCellViewModel class]];
        [self registerCellClass:[FRMyProfileWhyAreYouCell class] forModelClass:[FRMyProfileWhyAreYouCellViewModel class]];
        [self registerCellClass:[FRMyProfileInterestsCell class] forModelClass:[FRMyProfileInterestsCellViewModel class]];
        [self registerCellClass:[FRUserProfileInstagramPhotosCell class] forModelClass:[FRUserProfileInstagramPhotosCellViewModel class]];
        [self registerCellClass:[FRPhotosMutualFriendCell class] forModelClass:[FRPhotosMutualFriendCellViewModel class]];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDataSource:(FRUserProfileDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    
    switch (indexPath.row) {
        case FRUserProfileCellTypeHeader:
        {
          FRUserProfileHeaderCellViewModel* model = [storage itemAtIndexPath:indexPath];
            
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width - 40, CGFLOAT_MAX)];
            label.text = model.profession;
            label.adjustsFontSizeToFitWidth = YES;
            label.textAlignment = NSTextAlignmentCenter;
            label.numberOfLines = 0;
            [label sizeToFit];
            
            
           
            return 320 + label.bounds.size.height;
        } break;
            
        case FRUserProfileCellTypeInstagramPhotos:
        {
            FRUserProfileInstagramPhotosCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return model.heightCell;
        } break;
            
        case FRUserProfileCellTypeBioUser:
        {
            FRMyProfileUserBioCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return model.heightCell;
            
        } break;
            
        case FRUserProfileCellTypeWhyAreYouHere:
        {
            FRMyProfileWhyAreYouCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return model.cellHeight;
        } break;
            
        case FRUserProfileCellTypeInterests:
        {
            FRMyProfileInterestsCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return  [model height] + 75;

        } break;
            
        case FRUserProfileCellTypeMutualFriend:
        {
            FRPhotosMutualFriendCellViewModel* model = [storage itemAtIndexPath:indexPath];
            return [model height];

//            return 220;
        } break;
            
        default:
            return self.tableView.rowHeight;
            break;
    }
}

@end
