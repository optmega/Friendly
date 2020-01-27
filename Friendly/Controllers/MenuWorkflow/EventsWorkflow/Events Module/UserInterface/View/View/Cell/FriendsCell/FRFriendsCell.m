//
//  FRFriendsCell.m
//  Friendly
//
//  Created by Jane Doe on 4/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRFriendsCell.h"
#import "FRFriendsCellCollectionCell.h"
#import "FRFriendsTransport.h"

@interface FRFriendsCell() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) UIButton* filterButton;
@property (strong, nonatomic) UICollectionView* friendsCollection;
@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (strong, nonatomic) UIView* separator;

@end

@implementation FRFriendsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self filterButton];
        [self friendsCollection];
        [self separator];
    }
    return self;
}

- (void)updateWithModel:(FRFriendsCellViewModel*)model
{
    self.friendsArray = [NSMutableArray arrayWithArray:model.list];
}


#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.friendsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRFriendsCellCollectionCell *cell=(FRFriendsCellCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell updateWithModel:[self.friendsArray objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}



#pragma mark - LazyLoad

- (UIButton*) filterButton
{
    if (!_filterButton)
    {
        _filterButton = [UIButton new];
        [_filterButton setTitleColor:[UIColor bs_colorWithHexString:@"9CA0AB"] forState:UIControlStateNormal
         ];
        [_filterButton setTitle:@"AVAILABLE FOR MEET UP" forState:UIControlStateNormal];
        [_filterButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 15, 0, 0)];
        [_filterButton.titleLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(12)];
        [self.contentView addSubview:_filterButton];
        [_filterButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@41);
            make.top.left.right.equalTo(self.contentView);
        }];
    }
    return _filterButton;
}

- (UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        [_separator setBackgroundColor:[UIColor bs_colorWithHexString:kSeparatorColor]];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@1);
            make.bottom.left.right.equalTo(self.filterButton);
        }];
    }
    return _separator;
}

- (UICollectionView*) friendsCollection
{
    if (!_friendsCollection)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _friendsCollection = [[UICollectionView alloc] initWithFrame:self.contentView.frame collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [_friendsCollection registerClass:[FRFriendsCellCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [_friendsCollection setDataSource:self];
        [_friendsCollection setDelegate:self];
        
        [_friendsCollection setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_friendsCollection];
        
        [_friendsCollection mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.filterButton.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-10);
        }];

    }
    return _friendsCollection;
}

@end
