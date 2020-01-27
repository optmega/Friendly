//
//  FRCreateEventLocationSelectViewController.m
//  Friendly
//
//  Created by Jane Doe on 3/29/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventLocationSelectViewController.h"
#import "FRStyleKit.h"
#import "FRCreateEventLocationSelectTableViewCell.h"
#import "FRCreateEventLocationSelectSearchNearbyButton.h"
#import "FRLocationManager.h"
#import "FRCreateEventLocationPlaceModel.h"
#import "FRPlaceModel.h"
#import "FRPlaceDomainModel.h"
#import "FRLocationTransport.h"
#import "BSHudHelper.h"
#import "UIImageHelper.h"

@import GoogleMaps;

@interface FRCreateEventLocationSelectViewController() <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UIToolbar* toolbar;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UITextField* searchField;
@property (nonatomic, strong) NSArray* iconsArray;
@property (nonatomic, strong) FRCreateEventLocationSelectSearchNearbyButton* searchNearbyButton;
@property (nonatomic, strong) NSArray* responseArray;
@property (nonatomic, strong) FRCreateEventLocationPlaceModel* model;
@property (nonatomic, strong) NSArray* responseRecentlySearchedArray;
@property (nonatomic, strong) FRPlaceDomainModel* returnDomainModel;
@property (nonatomic, assign) BOOL isSearchStarted;
@property (nonatomic, strong) NSString* myLocationPlace;

@end

@implementation FRCreateEventLocationSelectViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.isSearchStarted = NO;
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self toolbar];
    [self tableView];
    [self backButton];
    [self.backButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self searchNearbyButton];
    
    [self searchField];
    [self.searchField addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    self.searchField.delegate = self;
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [FRLocationTransport getMyPlacesSuccess:^(FRPlacesModel *models) {
        self.responseRecentlySearchedArray = models.places;
        [self.tableView reloadData];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];

    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];

    }];
    [FRLocationTransport getMyLocationNameSuccess:^(NSString *place) {
        self.myLocationPlace = place;
        self.searchNearbyButton.subtitleLabel.text = place;
    } failure:^(NSError *error) {
        [BSHudHelper showHudWithType:BSHudTypeError view:self title:nil message:error.localizedDescription];
    }];
    
    UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
    [inpView addGestureRecognizer:gest];
    self.searchField.inputAccessoryView = inpView;

//    [self.searchField addSubview:clearButton];
//    self.iconsArray = [NSArray arrayWithObjects:[FRStyleKit imageOfSearchLocationCanvas], [FRStyleKit imageOfSearchLocationCanvas], [FRStyleKit imageOfSearchParkCanvas], nil];gy
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    setStatusBarColor([UIColor blackColor]);
}

#pragma mark - Actions

- (void) closeAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) selectingNearbyPlaces
{
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    [[FRLocationManager sharedInstance] startUpdateLocationManager];
    [FRLocationManager placeNearby:^(NSArray *places) {
        self.responseArray = places;
        
        [self.tableView reloadData];
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    }];

}

- (void) endEditing
{
    self.searchField.text = @"";
    [self.searchField endEditing:YES];
}

#pragma mark - TextFieldDelegate

- (void) textFieldDidChange: (UITextField *)textField
{
    NSLog( @"text changed: %@", textField.text);
    [BSHudHelper showHudWithType:BSHudTypeShowHud view:self title:nil message:nil];
    self.isSearchStarted = YES;
    [FRLocationManager placeAutocomplete:textField.text places:^(NSArray<GMSAutocompletePrediction *> *places)
     {
         self.responseArray = places;
         if (self.responseArray.count > 0)
         {
             [self.tableView reloadData];
         }
         [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
         [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
         [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];

     }];
    if ([textField.text isEqual:@""])
    {
        [BSHudHelper showHudWithType:BSHudTypeHideHud view:self title:nil message:nil];
    }
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@"What location?"]) {
        textField.text = @"";
        textField.textColor = [UIColor bs_colorWithHexString:@"ADB3C4"];
    }
    return YES;
}

- (BOOL) textFieldShouldEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:@""])
    {
        textField.text = @"What location?";
        textField.textColor = [[UIColor bs_colorWithHexString:@"ADB3C4"] colorWithAlphaComponent:0.5];
    }
    return YES;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - TableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.responseArray)
        {
            return self.responseArray.count;
        }
        else return 0;
    }
    else if (self.isSearchStarted)
    {
        return 0;
    }
    else
    {
        return self.responseRecentlySearchedArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 0;
    }
    else if (self.isSearchStarted)
        {
            return 0;
        }
    else
    {
        return 59;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 59)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 23.5, tableView.frame.size.width, 12)];
    [label setFont:FONT_SF_DISPLAY_SEMIBOLD(12)];
    [label setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
    NSString *string = @"RECENTLY SEARCHED";
    [label setText:string];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor whiteColor]];
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *returnCell;
    static NSString *CellIdentifier;
    CellIdentifier = @"LocationCell";
    FRCreateEventLocationSelectTableViewCell *locationSelectCell = (FRCreateEventLocationSelectTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];
    
    if (!locationSelectCell)
    {
        locationSelectCell = [[FRCreateEventLocationSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
  
    NSLog(@"%d , %d", indexPath.row, indexPath.section);
    
    
     if (indexPath.section == 0)
     {
         id object = [self.responseArray objectAtIndex:indexPath.row];
         
         if ([object isKindOfClass:[GMSAutocompletePrediction class]])
         {
             FRCreateEventLocationPlaceModel* cellModel = [FRCreateEventLocationPlaceModel initWithAutocompleteModel:[self.responseArray objectAtIndex:indexPath.row]];
                 [locationSelectCell updateCell:cellModel :@"" :YES];
     
             
             if(indexPath.row == totalRow -1)
             {
                     [locationSelectCell updateCell:cellModel :@"" :NO];
         
//                 [locationSelectCell updateCell:cellModel :[self.iconsArray objectAtIndex:indexPath.row] :NO];
             }

         }
         if ([object isKindOfClass:[GMSPlaceLikelihood class]])
         {
        
            GMSPlace* place = [(GMSPlaceLikelihood*)object place];
            FRCreateEventLocationPlaceModel* cellModel = [FRCreateEventLocationPlaceModel initWithNearbyModel:place];
                 [locationSelectCell updateCell:cellModel :@"" :YES];
           
//            [locationSelectCell updateCell:cellModel :[self.iconsArray objectAtIndex:indexPath.row] :YES];
            
            if(indexPath.row == totalRow -1)
            {
                    [locationSelectCell updateCell:cellModel :@"" :NO];
             
//                [locationSelectCell updateCell:cellModel :[self.iconsArray objectAtIndex:indexPath.row] :NO];
            }
         }
         
    }
    
    if (indexPath.section == 1)
    {
        FRCreateEventLocationPlaceModel* cellModel = [FRCreateEventLocationPlaceModel initWithRecentlySearchedModel:[self.responseRecentlySearchedArray objectAtIndex:indexPath.row]];
        [locationSelectCell updateCell:cellModel :@"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png" :YES];
        if(indexPath.row == totalRow -1)
        {
            [locationSelectCell updateCell:cellModel :@"https://maps.gstatic.com/mapfiles/place_api/icons/generic_business-71.png" :NO];
        }
    }
    
    returnCell = locationSelectCell;
    returnCell.selectionStyle = UITableViewCellSelectionStyleNone;

    return returnCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FRCreateEventLocationSelectTableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
    self.returnDomainModel = [FRPlaceDomainModel new];
    self.returnDomainModel.name = cell.selectedResponse.placeName;
    self.returnDomainModel.address = cell.selectedResponse.placeAddress;
    self.returnDomainModel.google_place_id = cell.selectedResponse.placeID;
    [self.delegate selectedLocation:cell.selectedResponse];
    [FRLocationTransport savePlace:self.returnDomainModel success:^(FRPlaceModel *model) {
    
    } failure:^{
        
    }];

    [self closeAction];
}


#pragma mark - LazyLoad

-(UIToolbar*) toolbar
{
  if (!_toolbar)
  {
      _toolbar = [UIToolbar new];
      _toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
      _toolbar.translucent = NO;
      _toolbar.barTintColor = [UIColor whiteColor];
      _toolbar.tintColor = [UIColor whiteColor];
      [self.view addSubview:_toolbar];
      [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.left.right.equalTo(self.view);
          make.height.equalTo(@65);
      }];
  }
    return _toolbar;
}

-(UIButton*) backButton
{
    if (!_backButton)
    {
        _backButton = [UIButton new];
        [_backButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AB0"]] forState:UIControlStateNormal];
        [self.toolbar addSubview:_backButton];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.toolbar).offset(10);
            make.bottom.equalTo(self.toolbar).offset(-10);
            make.height.width.equalTo(@30);
        }];
    }
    return _backButton;
}

-(UITextField*) searchField
{
    if (!_searchField)
    {
        _searchField = [UITextField new];
        _searchField.text = @"What location?";
        _searchField.autocorrectionType = UITextAutocorrectionTypeYes;
        _searchField.font = FONT_SF_DISPLAY_REGULAR(15);
        _searchField.clearButtonMode = UITextFieldViewModeWhileEditing;
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, _searchField.frame.size.height)];
        leftView.backgroundColor = _searchField.backgroundColor;
        _searchField.leftView = leftView;
        _searchField.leftViewMode = UITextFieldViewModeAlways;
        _searchField.textColor = [[UIColor bs_colorWithHexString:@"ADB3C4"] colorWithAlphaComponent:0.5];;
//        _searchField.backgroundColor =[[UIColor blackColor] colorWithAlphaComponent:0.24];;
        _searchField.backgroundColor = [UIColor bs_colorWithHexString:@"EFF1F6"];
        _searchField.layer.cornerRadius = 5;
        [self.toolbar addSubview:_searchField];
        [_searchField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.backButton.mas_right).offset(5);
            make.bottom.equalTo(self.toolbar).offset(-10);
            make.height.equalTo(self.backButton);
            make.right.equalTo(self.toolbar).offset(-15);
        }];
    
    }
    return _searchField;
}

-(UITableView*)tableView
{
    if (!_tableView)
    {
        _tableView = [[UITableView alloc] init];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = YES;
        _tableView.bounces = NO;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
            make.right.equalTo(self.view).offset(-15);
            make.left.equalTo(self.view).offset(15);
            make.top.equalTo(self.searchNearbyButton.mas_bottom);
        }];
    }
    return _tableView;
}

-(FRCreateEventLocationSelectSearchNearbyButton*) searchNearbyButton
{
    if (!_searchNearbyButton)
    {
        _searchNearbyButton = [FRCreateEventLocationSelectSearchNearbyButton new];
        [_searchNearbyButton addTarget:self action:@selector(selectingNearbyPlaces) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_searchNearbyButton];
        [_searchNearbyButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@72.5);
        }];
    }
    return _searchNearbyButton;
}

@end
