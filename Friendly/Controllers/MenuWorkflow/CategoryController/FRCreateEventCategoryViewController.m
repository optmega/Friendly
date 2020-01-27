//
//  FRAddEventCategoryViewController.m
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventCategoryViewController.h"
#import "FRCreateEventCategoryCollectionCell.h"
#import "FRStyleKitCategory.h"
#import "FRStyleKit.h"
#import "FRCategoryManager.h"
#import "UIImageHelper.h"

@interface FRCreateEventCategoryViewController() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UICollectionView* categoryCollection;
@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) NSArray* categoryIconsArray;
@property (strong, nonatomic) NSArray* categoryBackgroundsArray;
@property (strong, nonatomic) UIToolbar* toolbar;
@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UIButton* backButton;

@end

@implementation FRCreateEventCategoryViewController


- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
     [self categoryCollection];
     [self toolbar];
    [self titleLabel];
    [self backButton];
    [self.backButton addTarget:self action:@selector(backToCreating:) forControlEvents:UIControlEventTouchUpInside];
    self.categoryArray = [NSArray arrayWithObjects:@"Dining", @"Fun", @"Nightlife", @"Fitness", @"Outdoors", @"Travel", @"Community", @"Pets", @"Gay", @"Other", nil];
       self.categoryIconsArray = [NSArray arrayWithObjects:[FRStyleKitCategory imageOfIcondinningCanvas],
                                  [FRStyleKitCategory imageOfIconfunCanvas],
                                  [FRStyleKitCategory imageOfIconnightlifeCanvas],
                                  [FRStyleKitCategory imageOfIconfitnessCanvas],
                                  [FRStyleKitCategory imageOfIconoutdoorsCanvas],
                                  [FRStyleKitCategory imageOfIcontravelCanvas],
                                  [FRStyleKitCategory imageOfIconcommunityCanvas],
                                  [FRStyleKitCategory imageOfIconpetsCanvas],
                                  [FRStyleKitCategory imageOfIcongayCanvas],
                                  [FRStyleKitCategory imageOfIconotherCanvas], nil];
   self.categoryBackgroundsArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Categorie - Small - dinning"], [UIImage imageNamed:@"Categorie - Small - fun"], [UIImage imageNamed:@"Categorie - Small - nightlife"], [UIImage imageNamed:@"Categorie - Small - fitness"], [UIImage imageNamed:@"Categorie - Small - outdoors"], [UIImage imageNamed:@"Categorie - Small - travel"], [UIImage imageNamed:@"Categorie - Small - community"], [UIImage imageNamed:@"Categorie - Small - pets"], [UIImage imageNamed:@"Categorie - Small - gay"], [UIImage imageNamed:@"Categorie - Small - other"], nil];
    
    [self setStatusBarColor:[UIColor blackColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}


#pragma mark - Actions

- (void) backToCreating:(UIButton*)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRCreateEventCategoryCollectionCell *cell=(FRCreateEventCategoryCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell.icon setImage:[self.categoryIconsArray objectAtIndex:indexPath.row]];
    [cell.nameLabel setText:[self.categoryArray objectAtIndex:indexPath.row]];
    [cell.backgroundImageView setImage:[self.categoryBackgroundsArray objectAtIndex:indexPath.row]];
   // cell.layer.cornerRadius = 10;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double size = (self.view.frame.size.width/2)-16;
    return CGSizeMake(size, size);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate selectedCategory:[self.categoryArray objectAtIndex:indexPath.row] andId:[[FRCategoryManager getCategoryDictionary] objectForKey:[self.categoryArray objectAtIndex:indexPath.row]]];
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - LazyLoad

-(UIToolbar*) toolbar
{
    if (!_toolbar)
    {
        _toolbar = [UIToolbar new];
        _toolbar.translucent = NO;
        _toolbar.barTintColor = [UIColor whiteColor];
        _toolbar.tintColor = [UIColor whiteColor];
        _toolbar.frame = CGRectMake(0, 0, self.view.frame.size.width, 100);
        [self.view addSubview:_toolbar];
        [_toolbar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.equalTo(self.view);
            make.height.equalTo(@60);
        }];
    }
    return _toolbar;
}

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setText:@"Category"];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [_titleLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(18)];
        [self.toolbar addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.toolbar);
            make.bottom.equalTo(self.toolbar).offset(-15);
        }];
    }
    return _titleLabel;
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

-(UICollectionView*) categoryCollection
{
    if (!_categoryCollection)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //   FREventPreviewAttendingSmallFlowLayout *layout = [[FREventPreviewAttendingSmallFlowLayout alloc] init];
        
        _categoryCollection = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
        
        [_categoryCollection registerClass:[FRCreateEventCategoryCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
//        _categoryCollection.pagingEnabled = YES;
        [_categoryCollection setDataSource:self];
        [_categoryCollection setDelegate:self];
        [layout setSectionInset:UIEdgeInsetsMake(0, 0, 15, 0)];
        [_categoryCollection setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:_categoryCollection];
        
        [_categoryCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom).offset(15);
            make.left.equalTo(self.view).offset(15);
            make.right.equalTo(self.view).offset(-12);
            make.bottom.equalTo(self.view);
        }];
        
    }
    return _categoryCollection;
}

- (void)setStatusBarColor:(UIColor*)color
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
        
        [statusBar performSelector:setForegroundColor_sel withObject:color];
    }
}

@end
