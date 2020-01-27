//
//  FRMessagerContentView.h
//  Friendly
//
//  Created by Dmitry on 16.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventsHeaderView.h"

@interface FRMessagerContentView : UIView

@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UIView* headerView;

- (void)updateFriendsCount:(NSNumber*)count;    


@end
