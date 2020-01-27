//
//  FRSearchViewControllerVerticalCell.m
//  Friendly
//
//  Created by Jane Doe on 4/21/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerVerticalCell.h"
#import "FRCreateEventCategoryCollectionCell.h"
#import "FRStyleKitCategory.h"

@interface FRSearchViewControllerVerticalCell() <UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIView* separatorCell;
@property (strong, nonatomic) UICollectionView* cellCollectionView;
@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) NSArray* categoryIconsArray;
@property (strong, nonatomic) NSArray* categoryBackgroundsArray;

@end

@implementation FRSearchViewControllerVerticalCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self separatorCell];
        [self cellCollectionView];
      //  self.cellCollectionView.pagingEnabled = YES;
        self.categoryArray = [NSArray arrayWithObjects:@"Dining", @"Fun", @"Nightlife", @"Fitness", @"Outdoors", @"Travel", @"Community", @"Pets", @"Gay", @"Other", nil];
        self.categoryIconsArray =  [NSArray arrayWithObjects:[FRStyleKitCategory imageOfIcondinningCanvas],
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
    }
    return self;
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
        layout.minimumLineSpacing = 4;
        layout.minimumInteritemSpacing = 4;
     //   [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        [_cellCollectionView registerClass:[FRCreateEventCategoryCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        [_cellCollectionView setDataSource:self];
        [_cellCollectionView setDelegate:self];
        [_cellCollectionView setBackgroundColor:[UIColor whiteColor]];
        
        [self.contentView addSubview:_cellCollectionView];
        
        [_cellCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separatorCell).offset(20);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-15);
            make.bottom.equalTo(self).offset(-15);
        }];
    }
    return _cellCollectionView;
}
@end
