//
//  FREventImageSelectPhotoPreviewController.m
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectPhotoPreviewController.h"
#import "FReventImageSelectPreviewCollectionViewCell.h"
#import "InstagramImage.h"
#import "UIImageView+WebCache.h"

@interface FREventImageSelectPhotoPreviewController() <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) NSArray* gallery;
@property (strong, nonatomic) NSMutableArray* imagesGallery;
@property (strong, nonatomic) UICollectionView* collectionView;

@end

@implementation FREventImageSelectPhotoPreviewController

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.modalPresentationStyle = UIModalPresentationOverFullScreen;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    return self;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self collectionView];
    self.collectionView.hidden= YES;
    [self useImageButton];
    [self closeButton];
//    [self previewView];
//    self.previewView.hidden = YES;
    [self closeBackView];
    [self.view setBackgroundColor:[UIColor clearColor]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
{
    CGRect visibleRect = (CGRect){.origin = self.collectionView.contentOffset, .size = self.collectionView.bounds.size};
    CGPoint visiblePoint = CGPointMake(CGRectGetMidX(visibleRect), CGRectGetMidY(visibleRect));
    NSIndexPath *visibleIndexPath = [self.collectionView indexPathForItemAtPoint:visiblePoint];
//    self.backImage = [self.imagesGallery objectAtIndex:visibleIndexPath.item];
    self.model = [self.gallery objectAtIndex:visibleIndexPath.item];
}

-(void)closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)updateWithPhoto:(UIImage*)image andGallery:(NSArray*)gallery andModels:(NSArray *)models andIndex:(NSInteger)index
{
    self.imagesGallery = [NSMutableArray arrayWithArray:gallery];
    self.backImage = image;
    self.gallery = [NSArray arrayWithArray:models];
    [self.collectionView reloadData];
    [self.collectionView layoutIfNeeded];
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

-(void)useImage
{
    [self.delegate selectedPhoto:self.backImage with:self.model];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.closeDelegate closeVC];
    }];
}

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.gallery.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FReventImageSelectPreviewCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"preview1Cell" forIndexPath:indexPath];
    FRPictureModel* model = [self.gallery objectAtIndex:indexPath.item];
    [cell updateWithUrl:model.image_url];
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake([UIScreen mainScreen].bounds.size.width, 295);
}

#pragma mark - LazyLoad

-(UICollectionView*) collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _collectionView=[[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.minimumLineSpacing = 0;
        layout.minimumInteritemSpacing = 0;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[FReventImageSelectPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"preview1Cell"];
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.closeBackView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.centerY.equalTo(self.view).offset(-40);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@295);
        }];
    }
    return _collectionView;
}


-(UIButton*) useImageButton
{
    if (!_useImageButton)
    {
        _useImageButton = [UIButton new];
        [_useImageButton setTitle:@"Use image" forState:UIControlStateNormal];
        [_useImageButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _useImageButton.layer.cornerRadius = 6;
        [_useImageButton addTarget:self action:@selector(useImage) forControlEvents:UIControlEventTouchUpInside];
        _useImageButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(16);
        [_useImageButton setBackgroundColor:[UIColor bs_colorWithHexString:kPurpleColor]];
        [self.closeBackView addSubview:_useImageButton];
        [_useImageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
            make.left.equalTo(self.collectionView.mas_centerX).offset(5);
            make.width.equalTo(@115);
            make.height.equalTo(@40);
        }];
    }
    return _useImageButton;
}

-(UIButton*) closeButton
{
    if (!_closeButton)
    {
        _closeButton = [UIButton new];
        [_closeButton setTitle:@"Close" forState:UIControlStateNormal];
        _closeButton.titleLabel.font = FONT_PROXIMA_NOVA_SEMIBOLD(16);
        [_closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_closeButton setBackgroundColor:[UIColor bs_colorWithHexString:kFieldTextColor]];
        [_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        _closeButton.layer.cornerRadius = 6;
        [self.closeBackView addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.collectionView.mas_bottom).offset(10);
            make.right.equalTo(self.collectionView.mas_centerX).offset(-5);
            make.width.equalTo(@115);
            make.height.equalTo(@40);
        }];
    }
    return _closeButton;
}

-(UIView*)closeBackView
{
    if (!_closeBackView)
    {
        _closeBackView = [UIView new];
        [_closeBackView setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:0.9]];
            UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeView)];
        [_closeBackView addGestureRecognizer:tap];
        [self.view addSubview:_closeBackView];
        
        [_closeBackView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return _closeBackView;
}

@end
