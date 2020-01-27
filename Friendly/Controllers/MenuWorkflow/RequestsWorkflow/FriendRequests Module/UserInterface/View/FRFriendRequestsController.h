//
//  FRFriendRequestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//


@class FRFriendRequestsDataSource;


@interface FRFriendRequestsController : NSObject



- (instancetype)initWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NSMutableArray* headerModelArray;
@property (nonatomic, strong) NSMutableArray* friendsCellModelArray;
@property (nonatomic, strong) NSMutableArray* familiarCellModelArray;

@end
