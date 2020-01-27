//
//  FRSearchPeopleCell.m
//  Friendly
//
//  Created by Sergey Borichev on 20.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchPeopleCell.h"
#import "FRPhotosCollectionVeiwCell.h"


@interface FRSearchPeopleCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView* userPhotoImage;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* awayLabel;
@property (nonatomic, strong) UIButton* profileButton;
@property (nonatomic, strong) UIButton* addButton;
@property (nonatomic, strong) UIButton* friendsButton;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UILabel* bottomDataLabel;
@property (nonatomic, strong) UIButton* pendingButton;
@property (nonatomic, strong) FRSearchPeopleCellViewModel* model;


@end

static NSString* const kCellId = @"kCellId";

@implementation FRSearchPeopleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        @weakify(self);
        [[self.addButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model addSelected];
            self.addButton.hidden = YES;
            self.pendingButton.hidden = NO;
        }];
        
        [[self.profileButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model profileSelected];
        }];
        
        [[self.friendsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [self.model friendsSelected];
        }];
    }
    return self;
}



- (void)updateWithModel:(FRSearchPeopleCellViewModel*)model
{
    self.model = model;
    [model updateUserPhoto:self.userPhotoImage];
    self.nameLabel.text = model.userName;
    self.awayLabel.text = model.away;
    self.bottomDataLabel.attributedText = model.commonFriendsOrTag;
    
    NSInteger heightCollection = 125;

    if (model.instagramPhotos.count == 0)
    {
        heightCollection = 0;
    }
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@(heightCollection));
    }];
    
    self.friendsButton.hidden = YES;
    self.addButton.hidden = YES;
    self.pendingButton.hidden = YES;
    
    switch (model.isFriend) {
        case FRIsFriendNo:
        {
            self.addButton.hidden = NO;
        }  break;
        case FRIsFriendInvited:
        {
            self.pendingButton.hidden = NO;
        }  break;
        case FRIsFriendYes:
        {
            self.friendsButton.hidden = NO;
        }  break;
            
        default:
            break;
    }
    
    
    [self.collectionView reloadData];
}


#pragma mark - Lazy Load

- (UIImageView*)userPhotoImage
{
    if (!_userPhotoImage)
    {
        _userPhotoImage = [UIImageView new];
        _userPhotoImage.layer.cornerRadius = 25;
        _userPhotoImage.clipsToBounds = YES;
        [self.contentView addSubview:_userPhotoImage];
        
        [_userPhotoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.width.equalTo(@50);
            make.top.equalTo(self.contentView).offset(15);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _userPhotoImage;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _nameLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.userPhotoImage.mas_centerY);
            make.left.equalTo(self.userPhotoImage.mas_right).offset(10);
            make.right.equalTo(self.profileButton.mas_left).offset(-5);
        }];
    }
    return _nameLabel;
}

- (UILabel*)awayLabel
{
    if (!_awayLabel)
    {
        _awayLabel = [UILabel new];
        _awayLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _awayLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        [self.contentView addSubview:_awayLabel];
        
        [_awayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.userPhotoImage.mas_centerY);
            make.left.equalTo(self.userPhotoImage.mas_right).offset(10);
            make.right.equalTo(self.profileButton.mas_left).offset(-5);
        }];
    }
    return _awayLabel;
}

- (UIButton*)addButton
{
    if (!_addButton)
    {
        _addButton = [UIButton new];
        _addButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _addButton.backgroundColor = [UIColor bs_colorWithHexString:@"7B5AFA"];
        [_addButton setTitle:FRLocalizedString(@"Add", nil) forState:UIControlStateNormal];
        [_addButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _addButton.layer.cornerRadius = 4;
        [_addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_addButton];
        
        [_addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userPhotoImage);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@28);
            make.width.equalTo(@65);
        }];
    }
    return _addButton;
}

- (UIButton*)profileButton
{
    if (!_profileButton)
    {
        _profileButton = [UIButton new];
        _profileButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        [_profileButton setTitle:FRLocalizedString(@"Profile", nil) forState:UIControlStateNormal];
        _profileButton.layer.cornerRadius = 4;
        _profileButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _profileButton.layer.borderWidth = 1;
        [_profileButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_profileButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [self.contentView addSubview:_profileButton];
        
        [_profileButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userPhotoImage);
            make.height.equalTo(@28);
            make.width.equalTo(@65);
            make.right.equalTo(self.addButton.mas_left).offset(-5);
        }];
    }
    return _profileButton;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        [flowLayout setItemSize:CGSizeMake(140, 125)];
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:10.f];
        [flowLayout setSectionInset:UIEdgeInsetsMake(0, 15, 0, 15)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[FRPhotosCollectionVeiwCell class] forCellWithReuseIdentifier:kCellId];
        
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.userPhotoImage.mas_bottom).offset(10);
            make.height.equalTo(@125);
        }];
    }
    return _collectionView;
}

- (UILabel*)bottomDataLabel
{
    if (!_bottomDataLabel)
    {
        _bottomDataLabel = [UILabel new];
        _bottomDataLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _bottomDataLabel.textColor = [UIColor bs_colorWithHexString:@"9CA0AB"];
        
        [self.contentView addSubview:_bottomDataLabel];
        
        [_bottomDataLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
        }];
    }
    return _bottomDataLabel;
}

- (UIButton*)friendsButton
{
    if (!_friendsButton)
    {
        _friendsButton = [UIButton new];
        
        _friendsButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        _friendsButton.backgroundColor = [UIColor bs_colorWithHexString:kGreenColor];
        [_friendsButton setTitle:FRLocalizedString(@"Friend", nil) forState:UIControlStateNormal];
        [_friendsButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _friendsButton.layer.cornerRadius = 4;
        [_friendsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [self addSubview:_friendsButton];
        
        [_friendsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userPhotoImage);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@28);
            make.width.equalTo(@65);
        }];
    }
    return _friendsButton;
}

- (UIButton*)pendingButton
{
    if (!_pendingButton)
    {
        _pendingButton = [UIButton new];
        _pendingButton.layer.cornerRadius = 4;
        _pendingButton.layer.borderColor = [UIColor bs_colorWithHexString:kSeparatorColor].CGColor;
        _pendingButton.layer.borderWidth = 1;
        _pendingButton.titleLabel.font = FONT_SF_DISPLAY_REGULAR(12);
        [_pendingButton setTitleColor:[UIColor bs_colorWithHexString:kFieldTextColor] forState:UIControlStateNormal];
        [_pendingButton setTitle:FRLocalizedString(@"Pending", nil) forState:UIControlStateNormal];
        
        [self.contentView addSubview:_pendingButton];
        
        [_pendingButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.userPhotoImage);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@28);
            make.width.equalTo(@65);
        }];
    }
    return _pendingButton;
}


#pragma mark CollectionView DataSource / Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.instagramPhotos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRPhotosCollectionVeiwCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    [cell updateWIthPhotosUrl:[self.model.instagramPhotos objectAtIndex:indexPath.row]];
    return cell;
}


@end
