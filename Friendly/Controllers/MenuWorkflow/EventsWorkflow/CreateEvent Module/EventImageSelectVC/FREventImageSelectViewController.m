//
//  FREventImageSelectViewController.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventImageSelectViewController.h"
#import "UIImageHelper.h"
#import "FRStyleKit.h"
#import "FRStyleKitCategory.h"
#import "FREventImageSelectCategoryCell.h"
#import "FREventImageSelectImagesViewConroller.h"
#import "FRPhotoPickerController.h"
#import "FRImagesTransport.h"
#import "FRGalleryModel.h"

@interface FREventImageSelectViewController ()  <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FREventImageSelectCategoryCellDelegate, FREventImageSelectImagesViewConrollerCloseDelegate, FRPhotoPickerControllerCloseDelegate>

@property (strong, nonatomic) NSArray* categoryArray;
@property (strong, nonatomic) NSArray* categoryBackgroundArray;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) NSMutableArray* pictures;
@property (nonatomic, strong) FRPhotoPickerController* photoPickerController;

@end

@implementation FREventImageSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"Add event photo";
    [self selectLabel];
    [self selectCameraRollButton];
    [self collectionView];
    [self.closeButton setImage:[UIImageHelper image:[FRStyleKit imageOfNavBackCanvas] color:[UIColor bs_colorWithHexString:@"929AAF"]] forState:UIControlStateNormal];
    [self separator];
    self.categoryArray = [NSArray arrayWithObjects:@"Popular", @"Friends", @"Fitness/sport", @"Outdoors", @"Dining", @"Party", @"Animals", @"Business", @"Other", nil];
//    self.categoryBackgroundArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"gallery-popular"], [UIImage imageNamed:@"gallery-fun"], [UIImage imageNamed:@"gallery-sport"],[UIImage imageNamed:@"gallery-outdoors"],[UIImage imageNamed:@"gallery-dining"], [UIImage imageNamed:@"gallery-party"], [UIImage imageNamed:@"gallery-pets"],[UIImage imageNamed:@"gallery-business"], [UIImage imageNamed:@"gallery-other"], nil];
    self.categoryBackgroundArray = [NSArray arrayWithObjects:[UIImage imageNamed:@"gallery-popular"], [UIImage imageNamed:@"gallery-fun"], [UIImage imageNamed:@"gallery-sport"], [UIImage imageNamed:@"gallery-outdoors"], [UIImage imageNamed:@"gallery-dining"], [UIImage imageNamed:@"gallery-party"], [UIImage imageNamed:@"gallery-pets"], [UIImage imageNamed:@"gallery-business"], [UIImage imageNamed:@"gallery-other"], nil];
    [self setStatusBarColor:[UIColor blackColor]];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 9;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventImageSelectCategoryCell *cell=(FREventImageSelectCategoryCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"categoryCell" forIndexPath:indexPath];
    [cell.name setText:[self.categoryArray objectAtIndex:indexPath.row]];
    [cell.backView setImage:[self.categoryBackgroundArray objectAtIndex:indexPath.row] forState:UIControlStateNormal];
    cell.delegate = self;
    // cell.layer.cornerRadius = 10;
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    double size = (self.view.frame.size.width-73)/3;
//    return CGSizeMake(size, size);
    return CGSizeMake(size, size+40);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void) presentImagesVCWithCategory:(NSString*)category
{
    FREventImageSelectImagesViewConroller* imagesVC = [FREventImageSelectImagesViewConroller new];
    imagesVC.createPresenter = self.createPresenter;
    imagesVC.closeDelegate = self;
    [FRImagesTransport searchImagesByCategory:category success:^(FRGalleryModel *model)
    {
        self.pictures = [NSMutableArray arrayWithArray:model.pictures];
        [imagesVC updateWithImages:self.pictures];
        [self presentViewController:imagesVC animated:NO completion:nil];
    }
                failure:^(NSError *error) {
        //
                }];
}

- (void) presentPhotoPicker
{
    self.photoPickerController = [[FRPhotoPickerController alloc] initWithViewController:self];
    self.photoPickerController.quality = 0.9;
    self.photoPickerController.delegate = self.createPresenter;
    self.photoPickerController.closeDelegate = self;
}

- (void) closeVC
{
    [self dismissViewControllerAnimated:YES completion:nil];
}



#pragma mark - LazyLoad

-(UILabel*) selectLabel
{
    if (!_selectLabel)
    {
        _selectLabel = [UILabel new];
         [_selectLabel setFont:FONT_SF_DISPLAY_SEMIBOLD(12)];
         [_selectLabel setText:@"SELECT IMAGE CATEGORIE"];
        [_selectLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [self.view addSubview:_selectLabel];
        [_selectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.toolbar.mas_bottom).offset(35);
            make.left.equalTo(self.view).offset(20);
        }];
    }
    return _selectLabel;
}

-(UICollectionView*) collectionView
{
    if (!_collectionView)
    {
          UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
       
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:layout];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
        _collectionView.showsVerticalScrollIndicator = NO;
        [_collectionView registerClass:[FREventImageSelectCategoryCell class] forCellWithReuseIdentifier:@"categoryCell"];
        
        
        [_collectionView setDataSource:self];
        [_collectionView setDelegate:self];
        
        [_collectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.selectLabel.mas_bottom).offset(30);
            make.left.equalTo(self.view).offset(25);
            make.right.equalTo(self.view).offset(-25);
            make.bottom.equalTo(self.selectCameraRollButton.mas_top);
        }];
    }
    return _collectionView;
}

- (UIButton*) selectCameraRollButton
{
    if (!_selectCameraRollButton)
    {
        _selectCameraRollButton = [UIButton new];
        [_selectCameraRollButton setTitle:@"Select from Camera Roll" forState:UIControlStateNormal];
        _selectCameraRollButton.titleLabel.font = FONT_PROXIMA_NOVA_MEDIUM(18);
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

- (void)setStatusBarColor:(UIColor*)color
{
    id statusBarWindow = [[UIApplication sharedApplication] valueForKey:@"statusBarWindow"];
    id statusBar = [statusBarWindow valueForKey:@"statusBar"];
    
    SEL setForegroundColor_sel = NSSelectorFromString(@"setForegroundColor:");
    if([statusBar respondsToSelector:setForegroundColor_sel]) {
        // iOS 7+
        
        [statusBar performSelector:setForegroundColor_sel withObject:color];
    }
}

@end
