//
//  FRPhotosMutualFriendCell.m
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPhotosMutualFriendCell.h"
#import "FRProfileFriendCollectionCell.h"
#import "FRUserModel.h"

@interface FRPhotosMutualFriendCell () <UICollectionViewDelegate, UICollectionViewDataSource, FRProfileFriendCollectionCellDelegate>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) FRPhotosMutualFriendCellViewModel* model;

@end

static NSString* const kCellPhotoUserId = @"FRProfileFriendCollectionCell";

@implementation FRPhotosMutualFriendCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[FRProfileFriendCollectionCell class] forCellWithReuseIdentifier:kCellPhotoUserId];
    }
    return self;
}

- (void)updateWithModel:(FRPhotosMutualFriendCellViewModel*)model
{
    
    self.contentView.clipsToBounds = true;
    model.collectionView = self.collectionView;
    if (model.friends.count == 0) {
        self.collectionView.hidden = YES;
        self.titleLabel.hidden = YES;
    }
    else
    {
        self.collectionView.hidden = NO;
        self.titleLabel.hidden = NO;
    }
    self.model = model;
    if (model.isMyProfileCell)
    {
        self.titleLabel.text = model.friendsTitle;
    }
    else
    {
        self.titleLabel.text = model.title;
    }
    [self.collectionView reloadData];
}

-(void)showUserProfile:(NSString*)userId
{
    [self.model showUserProfile:userId];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.model showUserProfileWithEntity:user];
}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(40);
            make.left.equalTo(self.contentView).offset(17);
        }];
    }
    return _titleLabel;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumInteritemSpacing:3.f];
        [flowLayout setMinimumLineSpacing:3.f];
        [flowLayout setItemSize:CGSizeMake(78, 95)];
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 15, 10, 15)];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLabel.mas_bottom).offset(18);
            make.height.equalTo(@125);
        }];
    }
    return _collectionView;
}


#pragma  mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.friends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRProfileFriendCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellPhotoUserId forIndexPath:indexPath];
    cell.delegate = self;

    
    if ([[self.model.friends objectAtIndex:indexPath.row] isKindOfClass:[UserEntity class]]) {
        UserEntity* userModel = [self.model.friends objectAtIndex:indexPath.row];
        [cell updateWithUserEntityModel:userModel];
    }
    else
    {
        MutualUser* userModel = [self.model.friends objectAtIndex:indexPath.row];
        [cell updateWithModel:userModel];
    }
    
    if (indexPath.row != 0 && indexPath.row % (self.model.friends.count-1) == 0 ) {
       
        [self.model loadFriendsForNextPage];
    }


    return cell;
}

@end
