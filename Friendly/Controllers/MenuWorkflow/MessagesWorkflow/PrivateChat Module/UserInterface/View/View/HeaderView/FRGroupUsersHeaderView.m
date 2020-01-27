//
//  FRGroupUsersHeaderView.m
//  Friendly
//
//  Created by Dmitry on 04.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRGroupUsersHeaderView.h"
#import "FRMemberUserCollectionCell.h"
#import "MutualUser.h"

@interface FRGroupUsersHeaderView () <UICollectionViewDelegate, UICollectionViewDataSource, FRProfileFriendCollectionCellDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) UILabel* subtitle;

@property (nonatomic, strong) FRGroupUsersHeaderViewModel* model;

@property (nonatomic, strong) UIView* backSubtitle;
@end


static NSString* const cellId = @"CellID";

@implementation FRGroupUsersHeaderView


- (void)updateWithModel:(FRGroupUsersHeaderViewModel*)model
{
    self.backSubtitle.hidden = model.subtitle.length == 0;
    
    self.model = model;
    self.subtitle.text = model.subtitle;
    
    NSArray* users = [model.users filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"userId != %@", [FRUserManager sharedInstance].userId]];
    
    MutualUser* currentUsers = [MutualUser MR_createEntity];
    currentUsers.firstName = @"You";
    currentUsers.userId = [FRUserManager sharedInstance].userId;
    currentUsers.photo = [[FRUserManager sharedInstance].currentUser userPhoto];
    NSMutableArray* temp = [NSMutableArray array];
    [temp addObject:currentUsers];
    
    
    if (model.creator.userId != nil && ![model.creator.userId isEqualToString:currentUsers.userId]) {
        [temp addObject:model.creator];
    }
    
    if (model.cohost.userId != nil && ![model.cohost.userId isEqualToString:currentUsers.userId]) {
        [temp addObject:model.cohost];
    }
    [temp addObjectsFromArray:users];
    
    self.model.users = temp;
    
    
    CGFloat height = model.users.count ? 105: 0;
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(height));
    }];
   
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRMemberUserCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellId forIndexPath:indexPath];
    [cell updateWithModel:[self.model.users objectAtIndex:indexPath.row]];
    cell.delegate = self;
    return cell;
}

#pragma mark - FRProfileFriendCollectionCellDelegate

- (void)showUserProfile:(NSString*)userId {
    [self.delegate selectedUserId:userId];
}

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    
//    FRMemberUser* user = [self.model.users objectAtIndex:indexPath.row];
//    [self.model selectedUserId:user.userId];
//}

#pragma mark - LazyLoad

- (UIView*)backSubtitle
{
    if (!_backSubtitle)
    {
        _backSubtitle = [UIView new];
        _backSubtitle.backgroundColor = [UIColor whiteColor];
        [self addSubview:_backSubtitle];
        [_backSubtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self);
            make.bottom.equalTo(self.subtitle);
        }];
    }
    return _backSubtitle;
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
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15, 10, 15)];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        [_collectionView registerClass:[FRMemberUserCollectionCell class] forCellWithReuseIdentifier:cellId];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [self addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.top.equalTo(self).offset(3);
            make.height.equalTo(@105);
        }];

    }
    return _collectionView;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E4E6EA"];
        [self addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(2);
            make.left.equalTo(self).offset(0);
            make.right.equalTo(self).offset(0);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

- (UILabel*)subtitle
{
    if (!_subtitle)
    {
        _subtitle = [UILabel new];
        _subtitle.font = FONT_SF_TEXT_REGULAR(16);
        _subtitle.textAlignment = NSTextAlignmentCenter;
        _subtitle.textColor = [UIColor bs_colorWithHexString:KTextTitleColor];
        
        [self addSubview:_subtitle];
        [_subtitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(25);
            make.right.equalTo(self).offset(-25);
            make.top.equalTo(self.separator.mas_bottom).offset(8);
        }];
    }
    return _subtitle;
}
@end
