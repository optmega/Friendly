//
//  FRMyProfileShareInstagramCell.m
//  Friendly
//
//  Created by Sergey Borichev on 18.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileShareInstagramCell.h"
#import "FRStyleKit.h"
#import "FRPhotosCollectionVeiwCell.h"
#import "FRUserManager.h"

#import "FRSettingsTransport.h"
#import "FRUserModel.h"

@interface FRMyProfileShareInstagramCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UILabel* titleLabel;
@property (nonatomic, strong) UILabel* subtitleLabel;
@property (nonatomic, strong) UIButton* connectButton;
@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) UILabel* instagramTitleLabel;
@property (nonatomic, strong) FRProfileShareInstagramCellViewModel* model;

@end

static NSString* const kCellPhotoId = @"CellPhotoId";


@implementation FRMyProfileShareInstagramCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, 15);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[FRPhotosCollectionVeiwCell class] forCellWithReuseIdentifier:kCellPhotoId];
        self.collectionView.hidden = YES;
        self.instagramTitleLabel.hidden = YES;
    }
    return self;
}

- (void)updateWithModel:(FRProfileShareInstagramCellViewModel*)model
{
    self.model = model;
    self.titleLabel.text = model.title;
    self.model.photos = [FRUserManager sharedInstance].currentUser.images.allObjects;
    if([FRUserManager sharedInstance].currentUser.instagram_id>0)
    {
        model.isSelfInstagramConnected = YES;
    }
    else
    {
        model.isSelfInstagramConnected = NO;
    }
    self.subtitleLabel.text = model.subtitle;
    if (model.isSelfInstagramConnected)
    {
        self.instagramTitleLabel.hidden = NO;
        self.collectionView.hidden = NO;
        self.titleLabel.hidden = YES;
        self.subtitleLabel.hidden = YES;
        self.connectButton.hidden = YES;
        [self.collectionView reloadData];
        self.model.instagram_media_count = [FRUserManager sharedInstance].currentUser.instagramMediaCount;
        self.model.instagram_username = [FRUserManager sharedInstance].currentUser.instagramUsername;
        if (([self.model.instagram_media_count isEqualToString:@"0"])&&(self.model.instagram_username != nil))
        {
            [self.instagramTitleLabel setText:@"User has no instagram photos"];
            self.collectionView.hidden = YES;
            self.titleLabel.hidden = YES;
            self.subtitleLabel.hidden = YES;
            self.connectButton.hidden = YES;
        }
        else
        {
            [self.instagramTitleLabel setText:[NSString stringWithFormat:@"%@ %@", self.model.instagram_media_count, FRLocalizedString(@"Instagram photos", nil)]];
        }
    }
    else
    {
        self.instagramTitleLabel.hidden = YES;
        self.collectionView.hidden = YES;
        self.titleLabel.hidden = NO;
        self.subtitleLabel.hidden = NO;
        self.connectButton.hidden = NO;
    }
}

- (void)connectInstagram
{
    [self.delegate connectInstagram];
    [self.model connectSelected];

}


#pragma mark - Lazy Load

- (UILabel*)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = FONT_SF_DISPLAY_MEDIUM(16.5);
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.subtitleLabel.mas_top).offset(-5);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.connectButton.mas_left).offset(-10);
        }];
    }
    return _titleLabel;
}

- (UILabel*)instagramTitleLabel
{
    if (!_instagramTitleLabel)
    {
        _instagramTitleLabel = [UILabel new];
        _instagramTitleLabel.font = FONT_SF_DISPLAY_MEDIUM(17);
        _instagramTitleLabel.textColor = [UIColor bs_colorWithHexString:@"263345"];
        [_instagramTitleLabel setText:[NSString stringWithFormat:@"%@ %@", [FRUserManager sharedInstance].userModel.instagram_media_count, FRLocalizedString(@"Instagram photos", nil)]];

        [self.contentView addSubview:_instagramTitleLabel];
        
        [_instagramTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(17);
            make.top.equalTo(self.contentView).offset(30);
        }];

    }
    return _instagramTitleLabel;
}

- (UILabel*)subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        _subtitleLabel.textColor = [UIColor bs_colorWithHexString:@"BABDC4"];
        _subtitleLabel.font = FONT_SF_DISPLAY_REGULAR(15);
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_subtitleLabel];
        
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.connectButton);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.connectButton.mas_left).offset(-10);
        }];
    }
    return _subtitleLabel;
}

- (UIButton*)connectButton
{
    if (!_connectButton)
    {
        _connectButton = [UIButton new];
        _connectButton.backgroundColor = [UIColor bs_colorWithHexString:@"#FF6868"];
        [_connectButton setImage:[FRStyleKit imageOfInstagramCanvas] forState:UIControlStateNormal];
        _connectButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(14);
        _connectButton.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
        [_connectButton setTitle:@"Connect" forState:UIControlStateNormal];
        [_connectButton addTarget:self action:@selector(connectInstagram) forControlEvents:UIControlEventTouchUpInside];
        [_connectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_connectButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _connectButton.layer.cornerRadius = 5;

        [self.contentView addSubview:_connectButton];
        
        [_connectButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@102);
            make.height.equalTo(@35);
        }];
    }
    return _connectButton;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:10.f];
        [flowLayout setItemSize:CGSizeMake(140, 125)];
        
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 17, 10, 17)];
//        [_collectionView registerClass:[FRPhotosCollectionVeiwCell class] forCellWithReuseIdentifier:kCellPhotoId];
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 140, 125) collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        
        
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.top.equalTo(self.instagramTitleLabel.mas_bottom).offset(10);
            make.height.equalTo(@140);
        }];
    }
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.model.photos.count == 0)
    {
        return 0;
    }
    else
    {
        return self.model.photos.count+1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRPhotosCollectionVeiwCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellPhotoId forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    if (indexPath.item == self.model.photos.count)
    {
        [cell updateLastItem];
    }
    else
    {
        [cell updateWIthPhotosUrl:[self.model.photos objectAtIndex:indexPath.row]];
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.model.photos.count)
    {

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://instagram.com/%@", self.model.instagram_username]]];
    }
    else
        
    {
        FRPhotosCollectionVeiwCell* cell = (FRPhotosCollectionVeiwCell*)[self.collectionView cellForItemAtIndexPath:indexPath];
        [self.model showPreviewWithImage:cell.image.image];
    }
}




@end
