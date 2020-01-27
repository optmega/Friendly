//
//  FRSearchViewController.m
//  Friendly
//
//  Created by Jane Doe on 4/20/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewController.h"
#import "FRSearchViewControllerHorizontalCell.h"
#import "FRSearchViewControllerVerticalCell.h"
#import "FRSearchViewControllerRelatedCategoryCell.h"
#import "FRSearchViewControllerDiscoverPeopleCell.h"
#import "FREventsCell.h"
#import "FREventTransport.h"
#import "FREventModel.h"
#import "FREventsCellViewModel.h"
#import "FREventPreviewController.h"
#import "FRSearchDiscoverPeopleWireframe.h"
#import "FRStyleKit.h"
#import "FRSearchTransportService.h"
#import "FRSearchUserModel.h"
#import "FRSearchEventByCategoryWireframe.h"
#import "FRShareEventViewController.h"
#import "FRUserProfileWireframe.h"
#import "FRTransitionAnimator.h"


@class FREventModel, FREventModels;

@interface FRSearchViewController() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FRSearchViewControllerVerticalCellDelegate, FREventsCellViewModelDelegate, FRSearchViewControllerHorizontalCellDelegate>

@property (strong, nonatomic) UIToolbar* searchToolBar;
@property (strong, nonatomic) UITableView* searchTableView;
@property (strong, nonatomic) NSArray* headerCategorySearchList;
@property (strong, nonatomic) NSArray* headerNameSearchList;
@property (strong, nonatomic) UISearchBar* searchItem;
@property (assign, nonatomic) BOOL isCategorySearch;
@property (strong, nonatomic) NSArray* events;
@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) UIView* closeKeyboardView;
@property (strong, nonatomic) UIButton* closeButton;
@property (strong, nonatomic) UIButton* allCategoriesButton;

@property (strong, nonatomic) UIView* clearView;

@end

static NSString* const kHorizontalCategoryCell = @"horizontalCategoryCell";
static NSString* const kVerticalCategoryCell = @"verticalCategoryCell";
static NSString* const kRelatedCategoryCell = @"relatedCategoryCell";
static NSString* const kDiscoverPeopleCell = @"discoverPeopleCell";
static NSString* const kEventCell = @"eventCell";

@implementation FRSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker]; // 1
    [tracker set:kGAIScreenName value:@"CommonSearchScreen"];             // 2
    [tracker send:[[GAIDictionaryBuilder createAppView] build]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchToolBar];
    [self searchItem];
    [self searchTableView];
    [self closeKeyboardView];
    self.allCategoriesButton.hidden = YES;
    self.isCategorySearch = YES;
    self.closeKeyboardView.hidden = YES;
    self.closeButton.hidden = YES;
    self.headerCategorySearchList = [NSArray arrayWithObjects:@"OUR RECOMMENDATIONS", @"ALL CATEGORIES", nil];
    self.headerNameSearchList = [NSArray arrayWithObjects:@"RELATED CATEGORY", @"EVENT RESULTS", nil];
    [self clearView];
}

- (void)endEditing
{
    [self.searchItem endEditing:YES];
    self.searchItem.showsCancelButton = NO;
    self.closeKeyboardView.hidden = YES;
}

- (void)backToCategorySearch
{
    self.isCategorySearch = YES;
    self.searchItem.text = @"";
    self.searchItem.showsCancelButton = NO;
    [self.searchItem resignFirstResponder];
    [self.searchTableView reloadData];
    self.closeKeyboardView.hidden = YES;
    self.allCategoriesButton.hidden = YES;
    self.closeButton.hidden = YES;
    [self.searchItem mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchToolBar).offset(10);
    }];
}

- (void)shareEvent:(FREventModel*)event
{
    FRShareEventViewController* sVC = [FRShareEventViewController new];
    [sVC updateWithEvent:event];
    [self presentViewController:sVC animated:YES completion:nil];
}

- (void)userPhotoSelected:(NSString *)userId
{
    FRUserProfileWireframe* userWF = [[FRUserProfileWireframe alloc] init];
    [userWF presentUserProfileControllerFromNavigationController:self.navigationController userId:userId];
}

#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.closeKeyboardView.hidden = NO;
    self.isCategorySearch = NO;
    self.searchItem.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
    self.isCategorySearch = YES;
    [self.searchTableView reloadData];
    self.allCategoriesButton.hidden = YES;

    }
    else
    {
        self.closeButton.hidden = NO;
        [self.searchItem mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchToolBar).offset(40);
        }];
    self.isCategorySearch = NO;
    self.allCategoriesButton.hidden = NO;

    [FREventTransport searchEventsByTitle:searchText success:^(FREventSearchModels *models) {
        self.events = models.events;
        [self.searchTableView reloadData];
    }
    failure:^(NSError *error) {
        //
    }];
    [FRSearchTransportService searchUsersWithString:searchText success:^(FRSearchUsers *respons) {
        self.users = respons.users;
        [self.searchTableView reloadData];
    }
    failure:^(NSError *error) {
        //
    }];
    }
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

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    self.isCategorySearch = YES;
//    self.searchItem.text = @"";
//    self.searchItem.showsCancelButton = NO;
//    [self.searchItem resignFirstResponder];
//    [self.searchTableView reloadData];
//    self.closeKeyboardView.hidden = YES;
//    self.closeButton.hidden = YES;
//    [self.searchItem mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.searchToolBar).offset(10);
//    }];
    [self backToCategorySearch];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    CGRect frame = self.allCategoriesButton.frame;
//    if (scrollView.contentOffset.y>=self.searchTableView.frame.origin.y-30)
//    {
//    frame.origin.y = self.searchTableView.frame.origin.y - scrollView.contentOffset.y;
//    self.allCategoriesButton.frame = frame;
//    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.isCategorySearch)
    {
    return 2;
    }
    else
    {
    return 3;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==2)
    {
        return self.events.count; 
    }
    else
    {
    return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 2)
    {
    return 0;
    }
    else
    {
    return 30;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 18)];
    [label setFont:FONT_SF_DISPLAY_SEMIBOLD(13)];
    [label setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
    NSString* string = [NSString new];
    if (self.isCategorySearch)
    {
        string =[self.headerCategorySearchList objectAtIndex:section];
    }
    else
    {
       string = [self.headerNameSearchList objectAtIndex:section];
    }
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.section == 1)&(!self.isCategorySearch))
    {
        FRSearchDiscoverPeopleWireframe* peopleWF = [FRSearchDiscoverPeopleWireframe new];
        [peopleWF presentSearchDiscoverPeopleControllerFromNavigationController:self.navigationController tag:self.searchItem.text];
    }
    if ((indexPath.section == 1)&(self.isCategorySearch))
    {
    
    }
    if (indexPath.section == 2)
    {
        FREventModel* event = [self.events objectAtIndex:indexPath.row];
        NSString* eventId = event.id;
        FREventPreviewController* eventPreviewVC = [[FREventPreviewController alloc] initWithEventId:eventId andModel:event];
        UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:eventPreviewVC];
        nv.navigationBarHidden = YES;
//        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;

        [[FRTransitionAnimator new] presentViewController:nv from:self];

//        [self presentViewController:nv animated:YES completion:^{
//            //
//        }];
    }
    
    else return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* returnCell = [UITableViewCell new];
    if (indexPath.section == 0)
    {
        if (self.isCategorySearch)
        {
        FRSearchViewControllerHorizontalCell *cell = [tableView dequeueReusableCellWithIdentifier:kHorizontalCategoryCell];
        if (!cell)
        {
            cell = [[FRSearchViewControllerHorizontalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kHorizontalCategoryCell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.delegate = self;
        returnCell = cell;
        }
        else
        {
            FRSearchViewControllerRelatedCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedCategoryCell];

            if (!cell)
            {
                cell = [[FRSearchViewControllerRelatedCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRelatedCategoryCell];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;

        }
    }
   else if (indexPath.section == 1)
    {
        if (self.isCategorySearch) {
        FRSearchViewControllerVerticalCell *cell = [tableView dequeueReusableCellWithIdentifier:kVerticalCategoryCell];
            
        if (!cell)
        {
            cell = [[FRSearchViewControllerVerticalCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kVerticalCategoryCell];
        }
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;
        }
        else
        {
            FRSearchViewControllerDiscoverPeopleCell *cell = [tableView dequeueReusableCellWithIdentifier:kDiscoverPeopleCell];
            if (!cell)
            {
                cell = [[FRSearchViewControllerDiscoverPeopleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kDiscoverPeopleCell];
            }
            [cell updateWithUsers:self.users];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
        }
    }
    else if (indexPath.section == 2)
    {
        FREventsCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventCell];
        if (!cell)
        {
            cell = [[FREventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventCell];
        }
        FREventsCellViewModel* model = [FREventsCellViewModel initWithModel:[self.events objectAtIndex:indexPath.row]];
        model.delegate = self;
        [cell updateWithModel:model];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        returnCell = cell;
    }

    return returnCell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = ([UIScreen mainScreen].bounds.size.width-10)/2;

    if (indexPath.section == 0) {
        if (self.isCategorySearch)
        {
        return height+15;
        }
        else
        {
            return 150;
        }
    }
    if (indexPath.section == 1)
    {
        if (self.isCategorySearch)
        {
            return height*6;
        }
        else
        {
            return 70;
        }

    }
    if (indexPath.section == 2)
    {
    return 230;
    }
    else return 0;
}


#pragma mark - FRSearchViewControllerVerticalCellDelegate

- (void)selectedCategory:(NSString *)category
{
    [[FRSearchEventByCategoryWireframe new] presentSearchEventByCategoryControllerFromNavigationController:self.navigationController category:category];
}

#pragma mark - LazyLoad

- (UIToolbar*) searchToolBar
{
    if (!_searchToolBar)
    {
        _searchToolBar = [[UIToolbar alloc] init];
        _searchToolBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        [_searchToolBar setBarTintColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        _searchToolBar.translucent = NO;
        [self.view addSubview:_searchToolBar];
        [_searchToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@65);
        }];
    }
    return _searchToolBar;
}

- (UITableView*) searchTableView
{
    if (!_searchTableView)
    {
        _searchTableView = [UITableView new];
        _searchTableView.delegate = self;
        _searchTableView.dataSource = self;
        _searchTableView.showsVerticalScrollIndicator = NO;
        [_searchTableView registerClass:[FRSearchViewControllerHorizontalCell class] forCellReuseIdentifier:kHorizontalCategoryCell];
        [_searchTableView registerClass:[FRSearchViewControllerRelatedCategoryCell class] forCellReuseIdentifier:kRelatedCategoryCell];
        [_searchTableView registerClass:[FRSearchViewControllerVerticalCell class] forCellReuseIdentifier:kVerticalCategoryCell];
        [_searchTableView registerClass:[FRSearchViewControllerDiscoverPeopleCell class] forCellReuseIdentifier:kDiscoverPeopleCell];
        [_searchTableView registerClass:[FREventsCell class] forCellReuseIdentifier:kEventCell];
        _searchTableView.separatorColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.view addSubview:_searchTableView];
        [_searchTableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchToolBar.mas_bottom).offset(20);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _searchTableView;
}

- (UIView*) closeKeyboardView
{
    if (!_closeKeyboardView)
    {
        _closeKeyboardView = [UIView new];
        _closeKeyboardView.backgroundColor = [UIColor clearColor];
        UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
        [_closeKeyboardView addGestureRecognizer:gest];
        [self.view addSubview:_closeKeyboardView];
        [_closeKeyboardView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.searchToolBar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _closeKeyboardView;
}


- (UISearchBar*) searchItem
{
    if (!_searchItem)
    {
        _searchItem = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
        _searchItem.placeholder = @"Event search";
        [_searchItem setTintColor:[UIColor whiteColor]];
        _searchItem.delegate = self;
        [_searchItem setImage:[FRStyleKit imageOfTabSearchCanvas]
                forSearchBarIcon:UISearchBarIconSearch
                           state:UIControlStateNormal];
        UITextField *txtSearchField = [_searchItem valueForKey:@"_searchField"];
        txtSearchField.backgroundColor = [UIColor bs_colorWithHexString:@"5439CE"];
        txtSearchField.textColor = [UIColor whiteColor];
        txtSearchField.autocorrectionType = UITextAutocorrectionTypeYes;
        txtSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self.searchToolBar addSubview:_searchItem];
        [_searchItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchToolBar).offset(10);
            make.top.equalTo(self.searchToolBar).offset(20);
            make.bottom.equalTo(self.searchToolBar).offset(-5);
            make.right.equalTo(self.searchToolBar).offset(-10);
        }];
    }
    return _searchItem;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        
        [_closeButton setImage:[FRStyleKit imageOfNavBackCanvas] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(backToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
        [self.searchToolBar addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchToolBar).offset(10);
            make.centerY.equalTo(self.searchItem);
            make.height.width.equalTo(@20);
        }];
    }
    return _closeButton;
}

- (UIButton*) allCategoriesButton
{
    if (!_allCategoriesButton)
    {
        _allCategoriesButton = [UIButton new];
        [_allCategoriesButton setTitle:@"All categories" forState:UIControlStateNormal];
        [_allCategoriesButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _allCategoriesButton.layer.cornerRadius = 3;
        [_allCategoriesButton addTarget:self action:@selector(backToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
        [_allCategoriesButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        _allCategoriesButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(13);
        [self.view addSubview:_allCategoriesButton];
//        [self.view insertSubview:_allCategoriesButton belowSubview:self.searchToolBar];
        [_allCategoriesButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.searchTableView).offset(-10);
            make.top.equalTo(self.searchTableView);
            make.width.equalTo(@95.5);
            make.height.equalTo(@28);
        }];
    }
    return _allCategoriesButton;
}

- (UIView*) clearView
{
    if (!_clearView)
    {
        _clearView = [UIView new];
        [_clearView setBackgroundColor:[UIColor clearColor]];
        [self.searchTableView addSubview:_clearView];
        [_clearView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(self.searchTableView);
            make.height.equalTo(@30);
        }];
    }
    return _clearView;
}
@end
