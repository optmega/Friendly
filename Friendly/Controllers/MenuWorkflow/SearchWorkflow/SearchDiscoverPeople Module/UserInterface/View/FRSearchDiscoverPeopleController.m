//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleController.h"
#import "FRSearchDiscoverPeopleDataSource.h"
#import "FRSearchPeopleCell.h"
#import "FRSearchPeopleInviteCell.h"


@implementation FRSearchDiscoverPeopleController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRSearchPeopleCell class] forModelClass:[FRSearchPeopleCellViewModel class]];
        [self registerCellClass:[FRSearchPeopleInviteCell class] forModelClass:[FRSearchPeopleInviteCellViewModel class]];
    }
    return self;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"showAddUsers" object:nil];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

- (void)updateDataSource:(FRSearchDiscoverPeopleDataSource *)dataSource
{
    self.storage = dataSource.storage;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.row == 0)
    {
        return 85;
    }
    
    BSMemoryStorage* memoryStorage = self.memoryStorage;
    FRSearchPeopleCellViewModel* model = [memoryStorage itemAtIndexPath:indexPath];
    CGFloat height = model.instagramPhotos.count ? 248 : 110;
    
    return height;
}

@end
