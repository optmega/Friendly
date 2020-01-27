//
//  FREventCollectionCellFooter.m
//  Friendly
//
//  Created by Sergey Borichev on 14.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventCollectionCellFooter.h"
#import "FREventCollectionCellFooterViewModel.h"
#import "FRJoinUserCollectionCell.h"
#import "FREventOpenSlotsCollectionViewCell.h"



@interface FREventCollectionCellFooter() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UIView* dateView;
@property (nonatomic, strong) UIView* separator;
@property (nonatomic, strong) UICollectionView* usersCollectionView;

@property (nonatomic, strong) UILabel* dayNumberLabel;
@property (nonatomic, strong) UILabel* dayTextLabel;

@property (nonatomic, strong) NSArray* usersList;

@property (nonatomic, strong) FREventCollectionCellFooterViewModel* model;
@property (nonatomic, assign) NSInteger usersCount;

@end

static NSString* const kCellJoinUserId = @"kCellJoinUserId";
static NSString* const kCellOpenSlotsId = @"kCellOpenSlotsId";

@implementation FREventCollectionCellFooter

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self usersCollectionView];
        [self joinButton];
        self.dayTextLabel.text = @"SAT";
        self.dayNumberLabel.text = @"21";
    }
    return self;
}

- (void)updateWithModel:(FREventCollectionCellFooterViewModel*)model
{
    self.model = model;
    
    NSMutableArray* array = [NSMutableArray arrayWithArray:self.model.users];
    
    [array sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];
    
    self.usersCount = array.count;
    [array addObject:@(self.model.openSlots)];
    
    self.dayTextLabel.text = model.dayOfWeak;
    self.dayNumberLabel.text = model.dayOfMonth;
    self.usersList = [self _changeUsersArray:array];
    [self.usersCollectionView reloadData];
}

- (NSArray*)_changeUsersArray:(NSArray*)users
{
    NSMutableArray* array = [NSMutableArray array];
    NSInteger count = [UIScreen mainScreen].bounds.size.width <= 568.f ? 3 : 5;
    
    [users enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       if (idx > count)
       {
           *stop = YES;
       }
        [array addObject:obj];
    }];
    
    return array;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    if (section==0)
    {
        return self.usersList.count-1;
    }
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        FREventOpenSlotsCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellOpenSlotsId forIndexPath:indexPath];
        [cell updateWithModel:self.model.openSlots];
        return cell;
    }
   
    
    if (((self.usersList.count - 2) == indexPath.row) &&
       (((self.usersCount - (NSInteger)self.usersList.count)) > 1)){
        
        FRJoinUserEmptyCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRJoinUserEmptyCollectionCell" forIndexPath:indexPath];
        
        [cell updateWithCount:(self.usersCount - self.usersList.count + 2)];
         cell.layer.zPosition = self.usersList.count-1 - indexPath.row;
        
        return cell;
    }
        
        FRJoinUserCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellJoinUserId forIndexPath:indexPath];
        
        [cell updateWithModel:[self.usersList objectAtIndex:indexPath.row]];
        cell.layer.zPosition = self.usersList.count-1 - indexPath.row;
        
        return cell;
  }


#pragma mark - Lazy Load

- (UIView*)dateView
{
    if (!_dateView)
    {
        _dateView = [UIView new];
//        _dateView.layer.drawsAsynchronously = YES;
        [self addSubview:_dateView];
        
        [_dateView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(10);
            make.centerY.equalTo(self);
            make.width.equalTo(@40);
            make.height.equalTo(@34);
        }];
    }
    return _dateView;
}

- (UIView*)separator
{
    if (!_separator)
    {
        _separator = [UIView new];
//        _separator.layer.drawsAsynchronously = YES;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E1E3E8"];
        [self addSubview:_separator];
        
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.dateView.mas_right).equalTo(@10);
            make.width.equalTo(@1);
            make.height.equalTo(@26);
            make.centerY.equalTo(self);
        }];
    }
    return _separator;
}

- (UICollectionView*)usersCollectionView
{
    if (!_usersCollectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];

        [flowLayout setItemSize:CGSizeMake(25, 25)];
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:-7];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 5, 0, 0)];
        
        _usersCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//        _usersCollectionView.layer.drawsAsynchronously = YES;
        _usersCollectionView.delegate = self;
        _usersCollectionView.dataSource = self;
        _usersCollectionView.backgroundColor = [UIColor clearColor];
        [_usersCollectionView registerClass:[FRJoinUserCollectionCell class] forCellWithReuseIdentifier:kCellJoinUserId];
        
        [_usersCollectionView registerClass:[FRJoinUserEmptyCollectionCell class] forCellWithReuseIdentifier:@"FRJoinUserEmptyCollectionCell"];
        [_usersCollectionView registerClass:[FREventOpenSlotsCollectionViewCell class] forCellWithReuseIdentifier:kCellOpenSlotsId];
        [self addSubview:_usersCollectionView];
        
        [_usersCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.separator.mas_right).offset(15);
            make.right.equalTo(self.joinButton.mas_left).offset(-5);
            make.centerY.equalTo(self);
            make.height.equalTo(@30);
        }];
    }
    return _usersCollectionView;
}

- (UIButton*)joinButton
{
    if (!_joinButton)
    {
        _joinButton = [UIButton new];
//        _joinButton.layer.drawsAsynchronously = YES;
          _joinButton.backgroundColor = [UIColor bs_colorWithHexString:kPurpleColor];
        [_joinButton setTitle:@"Join" forState:UIControlStateNormal];
        [_joinButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _joinButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _joinButton.layer.cornerRadius = 5;
        [self addSubview:_joinButton];
        
        [_joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-20);
            make.height.equalTo(@31);
            make.width.equalTo(@75);
            make.centerY.equalTo(self);
        }];
    }
    return _joinButton;
}

- (UILabel*)dayTextLabel
{
    if (!_dayTextLabel)
    {
        _dayTextLabel = [UILabel new];
//        _dayTextLabel.layer.drawsAsynchronously = YES;
        _dayTextLabel.textAlignment = NSTextAlignmentCenter;
        _dayTextLabel.adjustsFontSizeToFitWidth = YES;
        _dayTextLabel.font = FONT_SF_DISPLAY_REGULAR(10);
        _dayTextLabel.textColor = [UIColor bs_colorWithHexString:@"#FF5454"];
        [self.dateView addSubview:_dayTextLabel];
        
        [_dayTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.equalTo(self.dateView);
            make.bottom.equalTo(self.dayNumberLabel.mas_top);
        }];
    }
    return _dayTextLabel;
}

- (UILabel*)dayNumberLabel
{
    if (!_dayNumberLabel)
    {
        _dayNumberLabel = [UILabel new];
//        _dayNumberLabel.layer.drawsAsynchronously = YES;
        _dayNumberLabel.textAlignment = NSTextAlignmentCenter;
        _dayNumberLabel.adjustsFontSizeToFitWidth = YES;
        _dayNumberLabel.textColor = [UIColor bs_colorWithHexString:@"#253244"];
        _dayNumberLabel.font = FONT_SF_DISPLAY_REGULAR(25);
        [self.dateView addSubview:_dayNumberLabel];
        
        [_dayNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.dateView);
            make.height.equalTo(@22);
        }];
    }
    return _dayNumberLabel;
}

@end
