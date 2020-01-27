//
//  FRShareEventViewController.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 05.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREvent;

#import "WhiteHeaderVC.h"
#import "FREventModel.h"

@interface FRShareEventViewController : WhiteHeaderVC

@property (strong, nonatomic) UITableView* tableView;
@property (strong, nonatomic) UIButton* eventLinkButton;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) FREvent* model;
@property (strong, nonatomic) UIButton* backButton;
@property (nonatomic, strong) UIImageView* overleyNavBar;

-(void)updateWithEvent:(FREvent*)event;

@end
