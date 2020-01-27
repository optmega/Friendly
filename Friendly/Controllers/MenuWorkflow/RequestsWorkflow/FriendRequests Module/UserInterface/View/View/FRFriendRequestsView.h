//
//  FRFriendRequestsView.h
//  Friendly
//
//  Created by Sergey Borichev on 08.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRRequestNavView;

@interface FRFriendRequestsView : UIView

@property (nonatomic, strong) FRRequestNavView* navBar;
@property (nonatomic, strong) UITableView* tableView;

@end
