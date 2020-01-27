//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryVC.h"
#import "FRSearchEventByCategoryController.h"
#import "FRSearchEventByCategoryDataSource.h"
#import "FRSearchEventByCategoryContentView.h"
#import "FRSearchEventByCategoryWireframe.h"
#import "FREmptyStateView.h"

@interface FRSearchEventByCategoryVC () <FRSearchEventByCategoryControllerDelegate, UISearchBarDelegate>

@property (nonatomic, strong) FRSearchEventByCategoryContentView* contentView;
@property (nonatomic, strong) FRSearchEventByCategoryController* controller;
@property (nonatomic, strong) FREmptyStateView* emptyStateView;

@end


@implementation FRSearchEventByCategoryVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRSearchEventByCategoryController alloc] initWithTableView:self.contentView.tableView];
        self.contentView.navBar.searchBar.delegate = self;
        self.controller.delegate = self;
    }

    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [FRUserManager sharedInstance].statusBarStyle = UIStatusBarStyleDefault;
    
    [super viewWillAppear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"SearchByCategoryScreen"];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self emptyStateView];
      @weakify(self);
    [[self.contentView.navBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
     if ([self.contentView.navBar.searchBar.text isEqualToString:@""]) {
        [self.eventHandler backSelected];
    }
}

#pragma mark - User Interface

- (void)updateDataSource:(FRSearchEventByCategoryDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
    if (dataSource.events.count == 0)
    {
        self.emptyStateView.hidden = NO;
    }
    else
    {
        self.emptyStateView.hidden = YES;
    }
}

- (void)updateSaerchBarText:(NSString*)text
{
    self.contentView.navBar.searchBar.text = text;
}

#pragma mark - FRTableController Delegate


- (FRSearchEventByCategoryContentView*)contentView
{
    if (!_controller)
    {
        _contentView = [FRSearchEventByCategoryContentView new];
        [self.view addSubview:_contentView];
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentView;
}

#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    
    BSDispatchBlockAfter(0.3, ^{
        
        setStatusBarColor([UIColor blackColor]);
    });
    return true;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    
    BSDispatchBlockAfter(1., ^{
        
        setStatusBarColor([UIColor blackColor]);
    });
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
//    if ([searchText isEqualToString:@""])
//    {
//        return;
//    }
    [self.eventHandler searchBar:searchText];
    setStatusBarColor([UIColor blackColor]);
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
    
    BSDispatchBlockAfter(0.2,^{
        
        setStatusBarColor([UIColor blackColor]);
    });
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    setStatusBarColor([UIColor blackColor]);
    
    if([text isEqualToString:@"\n"]) {
        [searchBar resignFirstResponder];
        return NO;
    }
    NSString *myRegex = @"[A-Z0-9a-z_ А-Яа-я]*";
    NSPredicate *myPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", myRegex];
    NSString *string = text;
    
    BOOL d = [myPredicate evaluateWithObject:string];
    return d;
}

#pragma mark - FRSearchEventByCategoryControllerDelegate

- (UITableView*)tableView {
    return  self.contentView.tableView;
}

- (void)selectedDiscoverPeople
{
    if (self.contentView.navBar.searchBar.text.length>0)
    {
        [self.eventHandler selectedDiscoverPeopleWithTag:self.contentView.navBar.searchBar.text];
    }
}

- (void)selectedEvent:(FREvent*)event
{
    [self.eventHandler selectedEvent:event fromFrame:CGRectZero];
}

- (FREmptyStateView*)emptyStateView
{
    if (!_emptyStateView)
    {
        _emptyStateView = [FREmptyStateView new];
        _emptyStateView.titleLabel.text = @"Nothings been hosted";
        _emptyStateView.subtitleLabel.text = @"Why not create event and show\nthem how it's done!";
        _emptyStateView.layer.zPosition = 3;
        [self.view addSubview:_emptyStateView];
        [_emptyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    return _emptyStateView;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

@end
