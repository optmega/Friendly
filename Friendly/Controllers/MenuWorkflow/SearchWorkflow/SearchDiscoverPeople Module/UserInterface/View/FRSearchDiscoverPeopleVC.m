//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleVC.h"
#import "FRSearchDiscoverPeopleController.h"
#import "FRSearchDiscoverPeopleDataSource.h"
#import "FRSearchDiscoverPeopleContentView.h"
#import "FRSearchDiscoverPeopleWireframe.h"

@interface FRSearchDiscoverPeopleVC ()<UISearchBarDelegate>

@property (nonatomic, strong) FRSearchDiscoverPeopleController* controller;
@property (nonatomic, strong) FRSearchDiscoverPeopleContentView* contentView;

@end


@implementation FRSearchDiscoverPeopleVC

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.controller = [[FRSearchDiscoverPeopleController alloc] initWithTableView:self.contentView.tableView];
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [APP_DELEGATE sendToGAScreen:@"SearchDiscoverPeopleScreen"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showAddUsers) name:@"showAddUsers" object:nil];
    @weakify(self);
    [[self.contentView.navBar.backButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        [self.eventHandler backSelected];
    }];
    
    self.contentView.navBar.searchBar.delegate = self;
}


#pragma mark - User Interface

- (void)updateDataSource:(FRSearchDiscoverPeopleDataSource *)dataSource
{
    [self.controller updateDataSource:dataSource];
}

- (void)updateSaerchBarText:(NSString*)text
{
    self.contentView.navBar.searchBar.text = text;
}


#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([searchText isEqualToString:@""])
    {
        return;
    }
    [self.eventHandler searchBar:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
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

#pragma mark - FRTableController Delegate


#pragma mark - Lazy Load

- (FRSearchDiscoverPeopleContentView*)contentView
{
    if (!_contentView)
    {
        _contentView = [FRSearchDiscoverPeopleContentView new];
        [self.view addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _contentView;
}

#pragma mark - Privates

- (void)showAddUsers
{
    [[FRSearchDiscoverPeopleWireframe new] presentRecomendedUsersFromNavigationController:self.navigationController];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    setStatusBarColor([UIColor blackColor]);
    return UIStatusBarStyleDefault;
}

@end
