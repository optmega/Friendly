//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendRequestsController.h"
#import "FRFriendRequestsDataSource.h"
#import "FRFriendRequestHeaderView.h"
#import "FRFriendRequestsCell.h"
#import "FRFriendFamiliarCell.h"
#import "MBProgressHUD.h"
#import "FRFriendRequestEmptyCell.h"


@interface FRFriendRequestsController () <UITableViewDelegate, UITableViewDataSource>

@end

static NSString* const frindCellId = @"FRFriendRequestsCellViewModel";
static NSString* const familiarCellId = @"FRFriendFamiliarCell";

@implementation FRFriendRequestsController

//а контроллер то переписать нужно

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super init];
    if (self)
    {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self.tableView registerClass:[FRFriendRequestHeaderView class] forHeaderFooterViewReuseIdentifier:@"FRFriendRequestHeaderViewModel"];
        [self.tableView registerClass:[FRFriendRequestsCell class] forCellReuseIdentifier:frindCellId];
        [self.tableView registerClass:[FRFriendFamiliarCell class] forCellReuseIdentifier:familiarCellId];
        

        
        [self.tableView registerNib:[UINib nibWithNibName:@"FRFriendRequestEmptyCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"EmptyCell"];
        
        
        self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0.01)];
        
        
        
        self.tableView.rowHeight = 70;
    }
    return self;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    if (section == 0 && self.friendsCellModelArray.count == 0) {
        return 0;
    }
    
    if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
        return 0;
    }
    
    if(section == 0 && self.friendsCellModelArray.count) {
        
        if (!self.friendsCellModelArray.count) {
            return 0;
        }
    } else {
        if (!self.familiarCellModelArray.count) {
            return  0;
        }
    }

        return 40;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    NSInteger sec = 0;
    
    if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
        return nil;
    }
    
    if(section == 0 && self.friendsCellModelArray.count) {
        
        if (!self.friendsCellModelArray.count) {
            return nil;
        }
        sec = section;
    } else {
        sec = 1;
    }
    if (section == 1) {
        if (!self.familiarCellModelArray.count) {
            return  nil;
        }
        sec = section;
    }
    
    FRFriendRequestHeaderView* headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FRFriendRequestHeaderViewModel"];
    [headerView updateWithModel:[self.headerModelArray objectAtIndex:sec]];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0 && self.friendsCellModelArray.count == 0 && self.familiarCellModelArray.count) {
        return 120;
    }
    
    if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
        return [UIScreen mainScreen].bounds.size.height - 180;
    }
    
    return tableView.rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    if ( self.familiarCellModelArray.count) {
        return 2;
    }
    
//    if (self.friendsCellModelArray.count && self.familiarCellModelArray.count) {
//        return 2;
//    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
        return 1;
    }

    if (section == 0)
    {
        if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
            
            return 1;
        }
        
        return [self.friendsCellModelArray count] ?: 1;
    }
    return [self.familiarCellModelArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (!self.friendsCellModelArray.count && !self.familiarCellModelArray.count) {
     
        UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        return cell;
    }
    
    if (indexPath.section == 0 && self.friendsCellModelArray.count == 0 && self.familiarCellModelArray.count) {
        UITableViewCell* cell =  [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        return cell;
    }
    
    id cell;
    if (indexPath.section == 0 && self.friendsCellModelArray.count)
    {
        FRFriendRequestsCellViewModel* model = [self.friendsCellModelArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:frindCellId forIndexPath:indexPath];
        [(FRFriendRequestsCell*)cell updateWithModel:model];
    }
    else
    {
        FRFriendFamiliarCellViewModel* model = [self.familiarCellModelArray objectAtIndex:indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:familiarCellId forIndexPath:indexPath];
        [(FRFriendFamiliarCell*)cell updateWithModel:model];

    }
    return  cell;
}

- (NSMutableArray*)headerModelArray
{
    if(!_headerModelArray)
    {
        _headerModelArray = [NSMutableArray array];
    }
    return _headerModelArray;
}

- (NSMutableArray*)friendsCellModelArray
{
    if (!_friendsCellModelArray)
    {
        _friendsCellModelArray = [NSMutableArray array];
    }
    return _friendsCellModelArray;
}

- (NSMutableArray*)familiarCellModelArray
{
    if (!_familiarCellModelArray)
    {
        _familiarCellModelArray = [NSMutableArray array];
    }
    return _familiarCellModelArray;
}

@end
