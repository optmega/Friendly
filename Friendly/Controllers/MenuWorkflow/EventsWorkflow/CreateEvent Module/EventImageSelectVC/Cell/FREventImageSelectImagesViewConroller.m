//
//  FREventImageSelectImagesViewConroller.m
//  Friendly
//
//  Created by Jane Doe on 5/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectImagesViewConroller.h"
#import "FREventImageSelectPhotoCell.h"
#import "UIImageHelper.h"
#import "FRStyleKit.h"
#import "FREventImageSelectPhotoPreviewController.h"
#import "FRPhotoPickerController.h"
#import "FRGalleryModel.h"
#import "UIImageView+WebCache.h"
#import "FREventImageSelectHeaderCell.h"

@interface FREventImageSelectImagesViewConroller() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FREventImageSelectPhotoPreviewControllerCloseDelegate, FRPhotoPickerControllerCloseDelegate>

@property (strong, nonatomic) UICollectionView* collectionImagesView;
@property (strong, nonatomic) UIButton* selectCameraRollButton;
@property (strong, nonatomic) UIView* separator;
@property (nonatomic, strong) FRPhotoPickerController* photoPickerController;
@property (strong, nonatomic) NSMutableArray* images;
@property (strong, nonatomic) NSMutableArray* imagesGallery;

@end

@implementation FREventImageSelectImagesViewConroller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Add event photo";
    [self collectionImagesView];
    [self selectCameraRollButton];
    [self.closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AAF"]] forState:UIControlStateNormal];
    self.automaticallyAdjustsScrollViewInsets = false;

    [self separator];
    
    self.imagesGallery = [NSMutableArray new];
}

-(void)updateWithImages:(NSMutableArray*)images
{
    self.images = [NSMutableArray arrayWithArray:images];
//    BSDispatchBlockToBackgroundQueue(^{
//        for ( FRPictureModel* model in self.images) {
//            NSURL *imageURL = [NSURL URLWithString:model.image_url];
//            NSData *imageData = [NSData dataWithContentsOfURL:imageURL];
//            UIImage *image = [UIImage imageWithData:imageData];
//            [self.imagesGallery addObject:image];
//        }
//    });
}

-(void)closeVC
{
    [self dismissViewControllerAnimated:NO completion:^{
        [self.closeDelegate closeVC];
    }];
}

-(void) backHome:(UIButton*)sender
{
    [self dismissViewControllerAnimated:NO completion:^{
        //
    }];
}

#pragma mark - CollectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell* cell = [UICollectionViewCell new];
    if (indexPath.item == 0)
    {
        FREventImageSelectHeaderCell* headerCell = (FREventImageSelectHeaderCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"headerCell" forIndexPath:indexPath];
        cell = headerCell;
    }
    else
    {
        FREventImageSelectPhotoCell *photoCell=(FREventImageSelectPhotoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"imageCell" forIndexPath:indexPath];
        photoCell.layer.cornerRadius = 7;
        NSLog(@"%ld", (long)indexPath.item);
        FRPictureModel* model = [self.images objectAtIndex:indexPath.item-1];
        
        NSURL* url = [NSURL URLWithString:model.image_url];
        [photoCell.backView sd_setImageWithURL:url completed:^(UIImage *image1, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image1)
        {
            [photoCell.backView setImage:image1];
//            if (![self.imagesGallery containsObject:image1])
//            {
//                [self.imagesGallery addObject:image1];
//            }
        }
        }];
        cell = photoCell;
    }
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //    double size = (self.view.frame.size.width/2)-18;
    //    return CGSizeMake(size, size);
    
     if (indexPath.item == 0)
    {
        return CGSizeMake([UIScreen mainScreen].bounds.size.width, 40);
    }
    else
    {
    return CGSizeMake(75, 65);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventImageSelectPhotoCell *cell = (FREventImageSelectPhotoCell*)[self.collectionImagesView cellForItemAtIndexPath:indexPath];
    FREventImageSelectPhotoPreviewController *previewVC = [FREventImageSelectPhotoPreviewController new];
    previewVC.delegate = (id<FREventImageSelectPhotoPreviewControllerDelegate>)self.createPresenter;
    previewVC.closeDelegate = self;
    [previewVC updateWithPhoto:cell.backView.image andGallery:self.imagesGallery andModels:self.images andIndex:indexPath.item-1];
    FRPictureModel* model = [self.images objectAtIndex:indexPath.item-1];
    previewVC.model = model;
    
    [self presentViewController:previewVC animated:YES completion:nil];
}

- (void) presentPhotoPicker
{
    self.photoPickerController = [[FRPhotoPickerController alloc] initWithViewController:self];
    self.photoPickerController.quality = 0.9;
    self.photoPickerController.delegate = self.createPresenter;
    self.photoPickerController.closeDelegate = self;
}

#pragma mark - LazyLoad

-(UICollectionView*) collectionImagesView
{
    if (!_collectionImagesView)
    {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        if( IS_IPHONE_5 )
        {
            layout.minimumInteritemSpacing = 27;
        }
        else if (IS_IPHONE_6)
        {
            layout.minimumInteritemSpacing = 11.5;
        }
        else if (IS_IPHONE_6_PLUS)
        {
            layout.minimumInteritemSpacing = 24.5;
        }
//        layout.minimumInteritemSpacing = 11.5;
        layout.minimumLineSpacing = 10;
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        layout.sectionInset = UIEdgeInsetsZero;
        _collectionImagesView.showsVerticalScrollIndicator = NO;

        _collectionImagesView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
      
        _collectionImagesView.collectionViewLayout = layout;

        [_collectionImagesView registerClass:[FREventImageSelectHeaderCell class] forCellWithReuseIdentifier:@"headerCell"];
        [_collectionImagesView registerClass:[FREventImageSelectPhotoCell class] forCellWithReuseIdentifier:@"imageCell"];
//
        
        [_collectionImagesView setDataSource:self];
        [_collectionImagesView setDelegate:self];
        
        [_collectionImagesView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:_collectionImagesView];
        
        [_collectionImagesView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom).offset(10);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.bottom.equalTo(self.selectCameraRollButton.mas_top);
        }];
    }
    return _collectionImagesView;
}



- (UIButton*) selectCameraRollButton
{
    if (!_selectCameraRollButton)
    {
        _selectCameraRollButton = [UIButton new];
        [_selectCameraRollButton setTitle:@"Select from Camera Roll" forState:UIControlStateNormal];
        _selectCameraRollButton.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(18);
        [_selectCameraRollButton addTarget:self action:@selector(presentPhotoPicker) forControlEvents:UIControlEventTouchUpInside];
        [_selectCameraRollButton setTitleColor:[UIColor bs_colorWithHexString:@"2C384A"] forState:UIControlStateNormal];
        [self.view addSubview:_selectCameraRollButton];
        [_selectCameraRollButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.view);
            make.height.equalTo(@51);
        }];
    }
    return _selectCameraRollButton;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self.view addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectCameraRollButton);
            make.left.equalTo(self.view).offset(20);
            make.right.equalTo(self.view).offset(-20);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

@end
