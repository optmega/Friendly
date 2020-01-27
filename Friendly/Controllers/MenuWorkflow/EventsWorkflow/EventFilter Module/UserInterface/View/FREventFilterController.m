//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterController.h"
#import "FREventFilterDataSource.h"
#import "FREventFilterSortByCell.h"
#import "FREventFilterViewConstatns.h"
#import "FREventFilterWhatYouSeeCell.h"
#import "FREventFilterDataCell.h"
#import "FREventFilterDistanceCell.h"
#import "FREventFilterAgeRangeCell.h"

@implementation FREventFilterController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FREventFilterSortByCell class] forModelClass:[FREventFilterSortByCellViewModel class]];
        [self registerCellClass:[FREventFilterWhatYouSeeCell class] forModelClass:[FREventFilterWhatYouSeeCellViewModel class]];
        [self registerCellClass:[FREventFilterDataCell class] forModelClass:[FRCreateEventAgeCellViewModel class]];
        [self registerCellClass:[FREventFilterDistanceCell class] forModelClass:[FREventFilterDistanceCellViewModel class]];
        [self registerCellClass:[FREventFilterAgeRangeCell class] forModelClass:[FREventFilterAgeRangeCellViewModel class]];
        
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.delegate selectedCell:indexPath.row];
}

- (void)updateDataSource:(FREventFilterDataSource *)dataSource
{
    self.storage = dataSource.storage;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case FREventFilterCellSortBy:
        {
            return 110;
        }  break;
        case FREventFilterCellWhatYouSee:
        {
            return 55;
        }  break;
        case FREventFilterCellDate:
        {
            return 55;
        }  break;
        case FREventFilterCellLocation:
        {
            return 55;
        }  break;
        case FREventFilterCellDistance:
        {
            return 100;
        }  break;
        case FREventFilterCellGender:
        {
            return 55;
        }  break;
        case FREventFilterCellAgeRange:
        {
            return 100;
        }  break;
            
        default:
            return 600;
            break;
    }
    return 120;
}

@end
