//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRAddInterestsController.h"
#import "FRAddInterestsDataSource.h"
#import "FRAddInterestsCell.h"
#import "FRAddInterestsHeaderView.h"


@implementation FRAddInterestsController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRAddInterestsCell class] forModelClass:[FRAddInterestsCellViewModel class]];
        [self.tableView registerClass:[FRAddInterestsHeaderView class] forHeaderFooterViewReuseIdentifier:@"FRAddInterestsHeaderView"];
//        self.tableView.bounces = NO;
        self.tableView.rowHeight = 45;
        self.tableView.clipsToBounds = YES;
    }
    return self;
}

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
//    [self.scrollDelegate changePositionY:scrollView.contentOffset.y];
//    [self.interestsScrollDeletage tableScrollViewDidScroll:scrollView];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 100;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    FRAddInterestsHeaderView* header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FRAddInterestsHeaderView"];
    header.clipsToBounds = YES;
//    header.layer.cornerRadius = 8;
    header.delegate = (id<FRAddInterestsHeaderViewDelegate>)self.interestsScrollDeletage;
    return header;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    BSMemoryStorage* storage = self.memoryStorage;
    
    FRAddInterestsCellViewModel* model = [storage itemAtIndexPath:indexPath];
    model.isCheck = !model.isCheck;
}

- (void)updateDataSource:(FRAddInterestsDataSource *)dataSource
{
    self.storage = dataSource.storage;
}


@end
