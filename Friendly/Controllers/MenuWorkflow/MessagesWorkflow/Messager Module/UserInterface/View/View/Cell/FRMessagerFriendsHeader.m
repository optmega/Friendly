//
//  FRMessagerFriendsHeader.m
//  Friendly
//
//  Created by Dmitry on 16.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMessagerFriendsHeader.h"
#import "FRProfileFriendCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"
#import "FRAddCollectionViewCell.h"


@interface FRMessagerFriendCollectionCell : UICollectionViewCell

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* faceBookLogoImage;
@property (strong, nonatomic) UIImageView* image;
@property (weak, nonatomic) id<FRProfileFriendCollectionCellDelegate> delegate;
@property (nonatomic, strong) UserEntity* model;

- (void)updateWithUserEntityModel:(UserEntity*)model;


@end

@implementation FRMessagerFriendCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)updateWithUserEntityModel:(UserEntity*)model
{
    self.model = model;
    
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:model.userPhoto]];
    
    [self.image sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
    self.nameLabel.text = model.firstName;
    [self faceBookLogoImage];
    
}

- (void)addMode {
    self.nameLabel.text = @"Add";
    self.image.image = [FRStyleKit imageOfActionBarAddUser];
}


#pragma mark - Lazy Load

- (UIImageView*)image
{
    if (!_image)
    {
        _image = [UIImageView new];
        _image.layer.cornerRadius = 30;
        _image.clipsToBounds = YES;
        _image.userInteractionEnabled = YES;
        [self.contentView addSubview:_image];

        [_image mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView);
            make.height.width.equalTo(@60);
            make.centerX.equalTo(self.contentView);
        }];
    }
    return _image;
}

- (UILabel*)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [UILabel new];
        _nameLabel.textColor = [UIColor bs_colorWithHexString:KTextTitleColor];
        _nameLabel.textAlignment = NSTextAlignmentCenter;       
        _nameLabel.font = FONT_PROXIMA_NOVA_MEDIUM(15);
        _nameLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.equalTo(self.contentView);
        }];
    }
    return _nameLabel;
}

- (UIImageView*)faceBookLogoImage
{
    if (!_faceBookLogoImage)
    {
        _faceBookLogoImage = [UIImageView new];
        _faceBookLogoImage.hidden = YES;
        _faceBookLogoImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_faceBookLogoImage];
        [_faceBookLogoImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.image).offset(4);
            make.right.equalTo(self.image);
            make.height.width.equalTo(@17);
        }];
    }
    return _faceBookLogoImage;
}

@end



@interface FRMessagerFriendsHeader () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) NSArray* friends;
@property (nonatomic, assign) NSInteger page;
@end

@implementation FRMessagerFriendsHeader

- (instancetype)init {
    self = [[[NSBundle mainBundle] loadNibNamed:@"FRMessagerFriendsHeader" owner:self options:nil] firstObject];
    self.page = 8;
    return self;
}

- (void)awakeFromNib {
    
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [flowLayout setMinimumInteritemSpacing:3.f];
    [flowLayout setMinimumLineSpacing:3.f];
    [flowLayout setItemSize:CGSizeMake(66, 78)];
    
    [flowLayout setSectionInset:UIEdgeInsetsMake(10, 15, 10, 15)];
    
    self.collectionView.collectionViewLayout = flowLayout;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor whiteColor];

    
    [self.collectionView registerClass:[FRMessagerFriendCollectionCell class] forCellWithReuseIdentifier:@"FRMessagerFriendCollectionCell"];
    [self.collectionView registerClass:[FRAddCollectionViewCell class] forCellWithReuseIdentifier:@"FRAddCollectionViewCell"];
}

- (void)updateWithFriends:(NSArray*)friends {
    self.friends = friends;
    [self.collectionView reloadData];
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.delegate countObject] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == [self.delegate countObject]) {
        
        FRAddCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FRAddCollectionViewCell" forIndexPath:indexPath];
        cell.nameLabel.text = @"Add";
        cell.image.image = [FRStyleKit imageOfCombinedShapeCanvas6];
        return cell;
    }
    
    FRProfileFriendCollectionCell* cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"FRMessagerFriendCollectionCell" forIndexPath:indexPath];
    
    [cell updateWithUserEntityModel:[self.delegate objectForIndexPath:indexPath]];
    if (indexPath.row != 0 && indexPath.row % self.page == 0 ) {
        [self.delegate updateAvailableFriends];
        self.page += 10;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    
    
    if (indexPath.row == [self.delegate countObject]) {
        
        [self.delegate showAddUsers];
        return;
    }
    [self.delegate selectedUser:[self.delegate objectForIndexPath:indexPath]];
}
@end
