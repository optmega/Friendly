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
#import "FREmptyStateView.h"
#import "FRSearchViewControllerHeaderView.h"
#import "BSHudHelper.h"
#import "UIImageHelper.h"
#import "FRSettingsTransport.h"

@class FREventModel, FREventModels;

@interface FRSearchViewController() <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, FRSearchViewControllerVerticalCellDelegate, FREventsCellViewModelDelegate, FRSearchViewControllerHorizontalCellDelegate>

@property (strong, nonatomic) UIToolbar* searchToolBar;
@property (strong, nonatomic) UITableView* searchTableView; //TODO: - если у нас всего одна таблица, ее нужно называть tableView
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
@property (assign, nonatomic) BOOL isRelatedCategoryResult;
@property (assign, nonatomic) BOOL isPeopleResult;
@property (assign, nonatomic) BOOL isEventsResult;
@property (strong, nonatomic) FREmptyStateView* emptyStateView;
@property (strong, nonatomic) FREventRelatedCategoryModel* relatedCategoryModel;

@end

static NSString* const kHorizontalCategoryCell = @"horizontalCategoryCell";
static NSString* const kVerticalCategoryCell = @"verticalCategoryCell";
static NSString* const kRelatedCategoryCell = @"relatedCategoryCell";
static NSString* const kDiscoverPeopleCell = @"discoverPeopleCell";
static NSString* const kEventCell = @"eventCell";

@implementation FRSearchViewController

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated]; //TODO: - всегда вызываем super в методах жизненного цикла
    [APP_DELEGATE sendToGAScreen:@"CommonSearchScreen"];
    
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self searchToolBar];
    [self searchItem];
    [self searchTableView];
    [self closeKeyboardView];
    [self closeButton];
    self.allCategoriesButton.hidden = YES;
    self.isCategorySearch = YES;
    self.closeKeyboardView.hidden = YES;
    self.headerCategorySearchList = [NSArray arrayWithObjects:@"OUR RECOMMENDATIONS", @"ALL CATEGORIES", nil];
    self.headerNameSearchList = [NSArray arrayWithObjects:@"RELATED CATEGORY", @"EVENT RESULTS", nil];
    [self clearView];
    self.isEventsResult = NO;
    self.isRelatedCategoryResult = NO;
    self.isPeopleResult = NO;
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor bs_colorWithHexString:@"#929AB0"]];
//    
//    UIGestureRecognizer* gest = [[UIGestureRecognizer alloc]initWithTarget:self action:@selector(dd)];
//    [self.closeKeyboardView addGestureRecognizer:gest];

    UISwipeGestureRecognizer* swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipe)];
    [self.closeKeyboardView addGestureRecognizer:swipe];
    swipe.cancelsTouchesInView = NO;
    swipe.direction = UISwipeGestureRecognizerDirectionUp | UISwipeGestureRecognizerDirectionDown;
}

- (void)swipe
{
    [self.searchItem endEditing:YES];
    self.searchItem.showsCancelButton = NO;
    self.closeKeyboardView.hidden = YES;
//    [self backToCategorySearch];
}

- (void)endEditing
{
    [self.searchItem endEditing:YES];
    self.searchItem.showsCancelButton = NO;
    self.closeKeyboardView.hidden = YES;
}

- (void)backToCategorySearch
{
    if (self.isCategorySearch)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        self.isCategorySearch = YES;
        self.searchItem.text = @"";
        self.searchItem.showsCancelButton = NO;
        [self.searchItem resignFirstResponder];
        [self.searchTableView reloadData];
        self.closeKeyboardView.hidden = YES;
        self.allCategoriesButton.hidden = YES;
        self.emptyStateView.hidden = YES;
    }
}

- (void)shareEvent:(FREvent*)event
{
    FRShareEventViewController* sVC = [FRShareEventViewController new];
    [sVC updateWithEvent:event];
    [self presentViewController:sVC animated:YES completion:nil];
}

- (void)userPhotoSelected:(NSString *)userId
{
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
        
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self user:userProfile fromLoginFlow:false];
        
    } failure:^(NSError *error) {
        
    }];
    
    if (user) {
        
        [[FRUserProfileWireframe new] presentUserProfileFromViewController:self user:user fromLoginFlow:false];
    }
    
    //TODO: userEntity
//    [userWF presentUserProfileControllerFromNavigationController:self.navigationController userId:userId];
}


#pragma mark - SearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.closeKeyboardView.hidden = NO;
    self.isCategorySearch = NO;
    self.searchItem.showsCancelButton = YES;
    if ([searchBar.text isEqualToString:@""])
    {
        self.emptyStateView.hidden = YES;
    }

}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    if (([searchText isEqualToString:@""])||(searchText.description == nil))
    {
        self.isCategorySearch = YES;
        [self.searchTableView reloadData];
        self.allCategoriesButton.hidden = YES;
        self.emptyStateView.hidden = YES;
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    }
    else
    {
        [self.searchItem mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchToolBar).offset(40);
        }];
        self.isCategorySearch = NO;
        [FREventTransport searchEventsByTitle:searchText success:^(FREventSearchEntityModels *models) {
            
            self.emptyStateView.titleLabel.text = @"Hmm nothing found";
            [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view);
            }];
            self.emptyStateView.hidden = NO;
            self.events = models.events;
            if (models.related_category.category_id!=nil)
            {
            
            self.isRelatedCategoryResult = YES;
            self.emptyStateView.titleLabel.text = @"No events or people found";
            [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.view).offset(50);
            }];
            self.relatedCategoryModel = models.related_category;
        }
        else
        {
            self.isRelatedCategoryResult = NO;
        }
        if (self.events.count != 0)
        {
            self.isEventsResult = YES;
            self.emptyStateView.hidden = YES;
        }
        else
        {
            self.isEventsResult = NO;
        }
            self.users = models.discover_people;
            if (models.discover_people.count != 0)
            {
                self.isPeopleResult = YES;
                //            self.emptyStateView.hidden = NO;
                self.emptyStateView.titleLabel.text = @"Hmm no events found";
                [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(self.view).offset(80);
                }];
                if ((IS_IPHONE_5)&&(self.isPeopleResult)&&(self.isRelatedCategoryResult))
                {
                    [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(self.view).offset(140);
                    }];
                }
                if ((IS_IPHONE_6)&&(self.isPeopleResult)&&(self.isRelatedCategoryResult))
                {
                    [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
                        make.centerY.equalTo(self.view).offset(150);
                    }];
                }

            }
            else
            {
                self.isPeopleResult = NO;
            }
        [self.searchTableView reloadData];
            if ([self.searchItem.text  isEqual: @""])
            {
                self.emptyStateView.hidden = YES;
            }
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    }
    failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];

//    [FRSearchTransportService searchUsersWithString:searchText success:^(FRSearchUsers *respons) {
//        [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
//        self.users = respons.users;
//        if (respons.users.count != 0)
//        {
//            self.isPeopleResult = YES;
////            self.emptyStateView.hidden = NO;
//            self.emptyStateView.titleLabel.text = @"Hmm no events found";
//            [self.emptyStateView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerY.equalTo(self.view).offset(80);
//            }];
//        }
//        else
//        {
//            self.isPeopleResult = NO;
//        }
//        [self.searchTableView reloadData];
//        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
//    }
//    failure:^(NSError *error) {
//        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:nil];
//
//        }];
    }
   //    [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
}

- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@""])
    {
        self.emptyStateView.hidden = YES;
    }
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
    [self backToCategorySearch];
}

-(void)selectedEvent:(FREventsCellViewModel *)viewModel
{
    
    CGRect cellRect = [self.searchTableView rectForRowAtIndexPath:[self.searchTableView indexPathForCell:viewModel.cell]];
    
    cellRect = CGRectOffset(cellRect, -self.searchTableView.contentOffset.x, -self.searchTableView.contentOffset.y);
    
    FREventsCell* cell = (FREventsCell*)viewModel.cell;
    
    cellRect.size = cell.eventImage.frame.size;
    cellRect.origin.y += self.searchTableView.frame.origin.y + 10;
    
    FREventPreviewController* eventPreviewVC = [[FREventPreviewController alloc] initWithEvent:[viewModel domainModel] fromFrame:cellRect];
    UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:eventPreviewVC];
    nv.navigationBarHidden = YES;
    nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
    nv.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;

    [[FRTransitionAnimator new] presentViewController:nv from:self];
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
    if ((!self.isCategorySearch)&&(!self.isRelatedCategoryResult)&&(section==0))
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
    FRSearchViewControllerHeaderView* view = [FRSearchViewControllerHeaderView new];
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width, 18)];
//    [label setFont:FONT_SF_DISPLAY_SEMIBOLD(13)];
//    [label setTextColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
    NSString* string = [NSString new];
    if (self.isCategorySearch)
    {
        string =[self.headerCategorySearchList objectAtIndex:section];
    }
    else
    {
       string = [self.headerNameSearchList objectAtIndex:section];
        if ((section == 0)&&(self.isRelatedCategoryResult))
        {
            view.allCategoriesButton.hidden = NO;
            [view.allCategoriesButton addTarget:self action:@selector(backToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            view.allCategoriesButton.hidden = YES;
        }
    }
//    [label setText:string];
//    [view addSubview:label];
    view.titleLabel.text = string;
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
    
    if (indexPath.section == 0) {
        FRSearchViewControllerRelatedCategoryCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [self selectedCategory:cell.category];
    }
    
    if (indexPath.section == 2)
    {
//        FREvent* event = [self.events objectAtIndex:indexPath.row];
//        FREventPreviewController* eventPreviewVC = [[FREventPreviewController alloc] initWithEvent:event];
//        UINavigationController* nv = [[UINavigationController alloc] initWithRootViewController:eventPreviewVC];
//        nv.navigationBarHidden = YES;
//        nv.modalPresentationStyle = UIModalPresentationOverFullScreen;
//
//        [[FRTransitionAnimator new] presentViewController:nv from:self];
//
//        [self presentViewController:nv animated:YES completion:^{
//            //
//        }];
    }
    
    else return;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* returnCell = [UITableViewCell new]; //TODO: так ячейки не создаются, моветон. В данном случае нужно оставить ее нилом
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
            if (self.isRelatedCategoryResult)
            {
            FRSearchViewControllerRelatedCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:kRelatedCategoryCell];

            if (!cell)
            {
                cell = [[FRSearchViewControllerRelatedCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRelatedCategoryCell];
            }
                [cell updateWithId:self.relatedCategoryModel.category_id andCounter:self.relatedCategoryModel.count];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            returnCell = cell;
            }
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
            if (self.isPeopleResult)
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
    }
    else if (indexPath.section == 2)
    {
        FREventsCell *cell = [tableView dequeueReusableCellWithIdentifier:kEventCell];
        if (!cell)
        {
            cell = [[FREventsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kEventCell];
        }
        
        FREvent* event = [[NSManagedObjectContext MR_defaultContext] objectWithID:[[self.events objectAtIndex:indexPath.row] objectID]];
        
        FREventsCellViewModel* model = [FREventsCellViewModel initWithEvent:event];
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

    if (indexPath.section == 0)
    {
        if (self.isCategorySearch)
        {
            return height+20;
        }
        else
        {
            if (self.isRelatedCategoryResult)
            {
                return 145;
            }
            else
                return 0;
        }
    }
    
    if (indexPath.section == 1)
    {
        if (self.isCategorySearch)
        {
            return height*5;
        }
        else
        {
            if (self.isPeopleResult)
            {
                return 70;
            }
            else
                return 0;
            
        }
    }
    
    if (indexPath.section == 2)
    {
        if (self.isEventsResult)
        {
            return 230;
        }
        else
            return 0;
    }
    
    else
        return 0;
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
        [_searchToolBar setBarTintColor:[UIColor whiteColor]];
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
        _searchTableView.separatorColor = [UIColor whiteColor];
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
//        _searchItem.placeholder = @"Event search";
        [_searchItem setTintColor:[UIColor whiteColor]];
        _searchItem.delegate = self;
        [_searchItem setImage:[UIImageHelper image:[FRStyleKit imageOfTabSearchCanvas2] color:[UIColor bs_colorWithHexString:@"ADB3C4"]]
                forSearchBarIcon:UISearchBarIconSearch
                           state:UIControlStateNormal];
        UITextField *txtSearchField = [_searchItem valueForKey:@"_searchField"];
        txtSearchField.backgroundColor = [UIColor bs_colorWithHexString:@"EFF1F6"];
        txtSearchField.textColor = [UIColor bs_colorWithHexString:@"ADB3C4"];
        txtSearchField.font = FONT_SF_DISPLAY_MEDIUM(15);
        txtSearchField.autocorrectionType = UITextAutocorrectionTypeYes;
        txtSearchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        if ([txtSearchField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
            UIColor *color = [UIColor bs_colorWithHexString:@"ADB3C4"];
            txtSearchField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"Event search             " attributes:@{NSForegroundColorAttributeName: color}];
        } else {
            NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        }
        [self.searchToolBar addSubview:_searchItem];
        [_searchItem mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.closeButton.mas_right).offset(5);
            make.top.equalTo(self.searchToolBar).offset(20);
            make.bottom.equalTo(self.searchToolBar).offset(-5);
            make.right.equalTo(self.searchToolBar).offset(-15);
        }];
    }
    return _searchItem;
}

- (UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        
        [_closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [_closeButton addTarget:self action:@selector(backToCategorySearch) forControlEvents:UIControlEventTouchUpInside];
        [self.searchToolBar addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.searchToolBar).offset(10);
            make.centerY.equalTo(self.searchItem);
            make.height.width.equalTo(@30);
        }];
    }
    return _closeButton;
}

- (FREmptyStateView*) emptyStateView
{
    if (!_emptyStateView)
    {
        _emptyStateView = [FREmptyStateView new];
        _emptyStateView.titleLabel.text = @"Hmm nothing found";
        _emptyStateView.subtitleLabel.text = @"Try searching again using a more\nbroad keyword like 'fitness'";
        [self.view addSubview:_emptyStateView];
        [self.view insertSubview:_emptyStateView aboveSubview:self.searchTableView];
        [_emptyStateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@50);
        }];
    }
    return _emptyStateView;
}


@end
