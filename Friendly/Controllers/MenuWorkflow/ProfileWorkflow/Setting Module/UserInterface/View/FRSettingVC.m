//
//  FRSettingInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 25.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSettingVC.h"
#import "FRSettingController.h"
#import "FRSettingDataSource.h"
#import "FRSettingContentView.h"


@interface FRSettingVC () <FRSettingControllerDelegate>

@property (nonatomic, strong) FRSettingController* controller;
@property (nonatomic, strong) FRSettingContentView* contentView;


@end


@implementation FRSettingVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.contentView = [FRSettingContentView new];
        self.controller = [[FRSettingController alloc] initWithTableView:self.contentView.tableView];
        self.controller.delegate = self;
        self.controller.scrollDelegate = self;
    }
    return self;
}

//- (void)loadView
//{
//    self.view = self.contentView;
//}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(50);
    }];
    
    @weakify(self);
    [[self.contentView.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    self.view.backgroundColor = [UIColor whiteColor];
}


#pragma mark - User Interface

- (void)updateDataSource:(FRSettingDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


#pragma mark - FRTableController Delegate

- (void)logOut
{
    [self.eventHandler logOutSelected];
}
@end
