//
//  FREventFilterInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 21.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventFilterVC.h"
#import "FREventFilterController.h"
#import "FREventFilterDataSource.h"
#import "FREventFilterContentView.h"

@interface FREventFilterVC () <FREventFilterControllerDelegate>

@property (nonatomic, strong) FREventFilterController* controller;
@property (nonatomic, strong) FREventFilterContentView* contentView;

@end


@implementation FREventFilterVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FREventFilterController alloc] initWithTableView:self.contentView.tableView];
        self.controller.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    @weakify(self);
    [[self.contentView.closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
   
    [[self.contentView.doneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler doneSelected];
    }];
}


#pragma mark - User Interface

- (void)updateDataSource:(FREventFilterDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}


#pragma mark - FRTableController Delegate

#pragma mark - Lazy Load

- (FREventFilterContentView*)contentView
{
    if (!_contentView)
    {
        _contentView = [FREventFilterContentView new];
        [self.view addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentView;
}

#pragma mark - FREventFilterControllerDelegate

- (void)selectedCell:(FREventFilterCellType)type
{
    switch (type) {
        case FREventFilterCellDate:
        {
            [self.eventHandler dateSelected];
        } break;
            
        case FREventFilterCellLocation:
        {
            [self.eventHandler locationSelected];
        } break;
        case FREventFilterCellGender:
        {
            [self.eventHandler genderSelected];
        } break;
            
        default:
            break;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

@end
