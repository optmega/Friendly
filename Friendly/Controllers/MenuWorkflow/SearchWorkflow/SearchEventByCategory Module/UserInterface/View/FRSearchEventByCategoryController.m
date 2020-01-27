//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryController.h"
#import "FRSearchEventByCategoryDataSource.h"
#import "FRSearchByCategoryMapCell.h"
#import "FRSearchByCategoryDiscoverPeopleCell.h"
#import "FRSearchByCategoryNearbyCell.h"
#import "FREventsCell.h"

@implementation FRSearchEventByCategoryController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRSearchByCategoryMapCell class] forModelClass:[FRSearchByCategoryMapCellViewModel class]];
        [self registerCellClass:[FRSearchByCategoryDiscoverPeopleCell class] forModelClass:[FRSearchByCategoryDiscoverPeopleCellViewModel class]];
        [self registerCellClass:[FRSearchByCategoryNearbyCell class] forModelClass:[FRSearchByCategoryNearbyCellViewModel class]];
        [self registerCellClass:[FREventsCell class] forModelClass:[FREventsCellViewModel class]];
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    
    switch (indexPath.row) {
        case 0:
        {
            FRSearchByCategoryMapCellViewModel* model = [storage itemAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            return [model heightCell];
        } break;
            
        case 1:
        {
  
            return 46;
        } break;
            
        case 2:
        {
            FRSearchByCategoryDiscoverPeopleCellViewModel* model = [storage itemAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
            return [model heightCell];
//            return 70;
        } break;
            
        default:
            break;
    }
    
    return 235;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 0:
        {
            return;
        } break;
        case 1:
        {
            return;
        } break;
        case 2:
        {
            [self.delegate selectedDiscoverPeople];
            return;
        } break;
        default:
            break;
    }
    
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    FREventsCellViewModel* eventModel = [storage itemAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:0]];
    [self.delegate selectedEvent:[eventModel domainModel]];
}

- (void)updateDataSource:(FRSearchEventByCategoryDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

@end
