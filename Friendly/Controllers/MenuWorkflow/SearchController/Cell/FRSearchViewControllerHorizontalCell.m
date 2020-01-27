//
//  FRSearchViewControllerHorizontalCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerHorizontalCell.h"
#import "FRCreateEventCategoryCollectionCell.h"
#import "FRStyleKitCategory.h"

@interface FRSearchViewControllerHorizontalCell() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView* separatorCell;
@property (strong, nonatomic) UICollectionView* cellCollectionView;
@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) NSArray* categoryIconsArray;
@property (strong, nonatomic) NSArray* categoryBackgroundsArray;

@end

@implementation FRSearchViewControllerHorizontalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        [self separatorCell];
        [self cellCollectionView];
        self.cellCollectionView.pagingEnabled = YES;
        self.categoryArray = [NSArray arrayWithObjects:@"Weekend", @"Popular", @"Nearest", @"Ending soon", nil];
        self.categoryIconsArray = [NSArray arrayWithObjects:[FRStyleKitCategory imageOfIconweekendCanvas], [FRStyleKitCategory imageOfIconpopularCanvas], [FRStyleKitCategory imageOfIconnearbyCanvas], [FRStyleKitCategory imageOfIconendingCanvas], nil];
        self.categoryBackgroundsArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"Categorie - Small - weekend"], [UIImage imageNamed:@"Categorie - Small - popular"], [UIImage imageNamed:@"Categorie - Small - nearby"], [UIImage imageNamed:@"Categorie - Small - ending"],  nil];
    }
    return self;
}

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 4;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
     FRCreateEventCategoryCollectionCell *cell=(FRCreateEventCategoryCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell.icon setImage:[self.categoryIconsArray objectAtIndex:indexPath.row]];
    [cell.nameLabel setText:[self.categoryArray objectAtIndex:indexPath.row]];
    [cell.backgroundImageView setImage:[self.categoryBackgroundsArray objectAtIndex:indexPath.row]];
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    cell.layer.cornerRadius = 10;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat heightWidth = ([UIScreen mainScreen].bounds.size.width-34.5)/2;
    return CGSizeMake(heightWidth, heightWidth);

}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* title = [self.categoryArray objectAtIndex:indexPath.row];
    [self.delegate selectedCategory:title];
}

#pragma mark - LazyLoad

- (UIView*) separatorCell
{
    if(!_separatorCell)
    {
        _separatorCell = [UIView new];
        _separatorCell.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_separatorCell];
        [_separatorCell mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@1);
            make.top.equalTo(self.contentView);
        }];
        
    }
    return _separatorCell;
}

- (UICollectionView*) cellCollectionView
{
    if (!_cellCollectionView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _cellCollectionView=[[UICollectionView alloc] initWithFrame:self.contentView.frame collectionViewLayout:layout];
        layout.minimumLineSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _cellCollectionView.showsHorizontalScrollIndicator = NO;
        [_cellCollectionView registerClass:[FRCreateEventCategoryCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_cellCollectionView setDataSource:self];
        [_cellCollectionView setDelegate:self];
  
        [_cellCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:_cellCollectionView];
        
        [_cellCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separatorCell).offset(20);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _cellCollectionView;
}


@end
