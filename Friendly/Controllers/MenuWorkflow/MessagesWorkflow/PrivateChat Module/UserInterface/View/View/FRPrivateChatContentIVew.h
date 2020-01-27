//
//  FRPrivateChatContentIVew.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRPrivateChatHeaderView.h"
#import "FRGroupChatNavigationView.h"

@interface FRPrivateChatContentIVew : UIView

@property (nonatomic, strong) FRPrivateChatHeaderView* headerView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) FRGroupChatNavigationView* navBar;

@end
