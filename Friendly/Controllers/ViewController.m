//
//  ViewController.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "ViewController.h"
#import "FRSegmentView.h"
#import "FRStyleKit.h"
#import "FRSettingsTransport.h"
#import "FREventCollectionCell.h"
#import "FREventTransport.h"
#import "FREventModel.h"
#import "FREventListCollevtionCell.h"
#import "FREventPreviewController.h"
#import "FREventSubCollectionCell.h"
#import "FRMyProfileWireframe.h"
#import "UIImageView+WebCache.h"

@interface ViewController () <UICollectionViewDelegate, UICollectionViewDataSource, FREventPreviewControllerDelegate>

@property (nonatomic, strong) FRSegmentView* segmentView;
@property (nonatomic, strong) NSArray* eventList;
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UICollectionView* collectionView;\

@property (nonatomic, assign) CGRect cellFrameInSuperview;
@property (nonatomic, assign) CGRect cellFrameInPreviewView;
@property (nonatomic, assign) CGRect colelctionCellFrameInSuperview;
@property (nonatomic, strong) UIImageView* selectedCellImage;
@property (nonatomic, strong) UIView* whiteView;
@property (nonatomic) BOOL isCVCell;


@end

static NSString* const kCellEventID = @"kCellEventId";
static NSString* const kCellSubEventID = @"kCellSubEventId";
static NSString* const kCellEventListID = @"kCellEventListID";


@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self segmentView];
    [self whiteView];
    
    [[UINavigationBar appearance] setBarTintColor:[UIColor bs_colorWithHexString:@"795EFF"]];
    [[UINavigationBar appearance] setTranslucent:NO];
    
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    [face addTarget:self action:@selector(showUserProfile) forControlEvents:UIControlEventTouchUpInside];
    
   
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:[USER_DEFAULTS objectForKey:kUserPhoto]]];
    [face.imageView sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [face setImage:image forState:UIControlStateNormal];
    }];
    face.bounds = CGRectMake( 0, 0, 30, 30 );
    face.imageView.bounds = CGRectMake(0, 0, 30, 30);
    face.clipsToBounds = YES;
    face.layer.cornerRadius = 15;
    face.layer.borderWidth = 2;
    face.layer.borderColor = [UIColor whiteColor].CGColor;
    face.backgroundColor = [UIColor blackColor];
    
    
    UIBarButtonItem *faceBtn = [[UIBarButtonItem alloc] initWithCustomView:face];
    
    UIButton* filter = [UIButton buttonWithType:UIButtonTypeCustom];
    [filter setImage:[FRStyleKit imageOfNavFilterCanvas] forState:UIControlStateNormal];
    filter.bounds = CGRectMake( 0, 0, 26, 26 );
     UIBarButtonItem *filterBtn = [[UIBarButtonItem alloc] initWithCustomView:filter];
    UIBarButtonItem* space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem* customSearch = [[UIBarButtonItem alloc] initWithCustomView:self.searchBar];

    self.navigationItem.leftBarButtonItems = @[faceBtn, space, customSearch, space, filterBtn];

    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setBackgroundColor:[UIColor bs_colorWithHexString:@"#F4F5F8"]];
    
    for (UIView *subview in self.searchBar.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                textField.backgroundColor = [UIColor bs_colorWithHexString:@"#5945BC"];
                textField.textColor = [UIColor whiteColor];
                
                UIView* inpView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
                UITapGestureRecognizer* gest = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEditing)];
                [inpView addGestureRecognizer:gest];
                
                textField.inputAccessoryView = inpView;
                
                
                UIImage* image = [FRStyleKit  imageOfTabSearchCanvas];
                UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
                imageView.frame = CGRectMake(0, 0, 15, 15);
                imageView.contentMode = UIViewContentModeScaleAspectFit;
                textField.leftView = imageView;
                
                break;
            }
        }
    }
    
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[FREventCollectionCell class] forCellWithReuseIdentifier:kCellEventID];
    [self.collectionView registerClass:[FREventListCollevtionCell class] forCellWithReuseIdentifier:kCellEventListID];
    [self.collectionView registerClass:[FREventSubCollectionCell class] forCellWithReuseIdentifier:kCellSubEventID];
    
    [self.collectionView reloadData];
}

- (void)endEditing
{
    [self.searchBar setText:@""];
    [self.searchBar resignFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
    [FREventTransport getFeaturedListWithSuccess:^(FREventModels *models) {
        self.eventList = models.events;
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)showUserProfile
{
    [[FRMyProfileWireframe new] presentMyProfileControllerFromNavigationController:self.navigationController];
}


#pragma mark - LazyLoad

- (UIView*)whiteView
{
    if (!_whiteView)
    {
        _whiteView = [UIView new];
        _whiteView.backgroundColor = [UIColor whiteColor];
        _whiteView.alpha = 0;
        [self.view insertSubview:_whiteView aboveSubview:self.collectionView];
        [_whiteView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.bottom.equalTo(self.view);
        }];
    }
    return _whiteView;
}


- (FRSegmentView*)segmentView
{
    if (!_segmentView)
    {
        _segmentView = [FRSegmentView new];
        _segmentView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_segmentView];
        
        [_segmentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.right.equalTo(self.view);
            make.height.equalTo(@(44));
        }];
    }
    return _segmentView;
}

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];        
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:10.f];
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 0, 10, 0)];
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 200, 200) collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor bs_colorWithHexString:@"E8EBF1"];
        [self.view addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segmentView.mas_bottom);
            make.left.right.bottom.equalTo(self.view);
        }];
    }
    return _collectionView;
}

- (UISearchBar*)searchBar
{
    if (!_searchBar)
    {
        CGFloat width = [UIScreen mainScreen].bounds.size.width-110;
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, width, 35)];
        _searchBar.delegate  = self;
        _searchBar.backgroundImage = [[UIImage alloc] init];
        _searchBar.placeholder = FRLocalizedString(@"Search", nil);
        [self.view addSubview:_searchBar];
    }
    return _searchBar;
}


#pragma mark - CollectionView

#pragma mark UICollectionViewDataSource


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.eventList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        FREventListCollevtionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellEventListID forIndexPath:indexPath];
        [cell updateWithModel:self.eventList];
        cell.clipsToBounds = YES;
        cell.delegate = self;
        
        return cell;
    }
    
    FREventSubCollectionCell*  cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellSubEventID forIndexPath:indexPath];

    [cell updateViewModel:[self.eventList objectAtIndex:(indexPath.row - 1)]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    if (indexPath.row == 0) {
        return CGSizeMake(width, 315);
    }
    else {
        return CGSizeMake(width, 225);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventModel* event = [self.eventList objectAtIndex:indexPath.row - 1];
    self.isCVCell = NO;
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    
    self.cellFrameInSuperview = [collectionView convertRect:cellRect toView:[collectionView superview]];
   
    [self selectingCell:self.cellFrameInSuperview :[UIImage imageNamed:@"imageEvent"]];
    
    NSLog(@"%f",self.cellFrameInSuperview.origin.y);
    
        [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.alpha = 0;
        self.whiteView.alpha = 1;
        self.selectedCellImage.frame = self.cellFrameInPreviewView;
        
    } completion:^(BOOL finished) {
        
        FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEventId:event.id];
        vc.delegate = self;
        
        [self presentViewController:vc animated:NO completion:^{}];
        
    }];

    //    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:event.image_url]];
//    [self.selectedCellImage sd_setImageWithURL:url placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        [self.selectedCellImage setImage:image];
//    }];
}

- (void)selectingCell:(CGRect)attributes :(UIImage*)image
{
    self.selectedCellImage = [UIImageView new];
    [self.view addSubview:self.selectedCellImage];
    CGRect frameRect = attributes;
    frameRect.size.height = attributes.size.height-55;
    self.cellFrameInSuperview = frameRect;
    self.selectedCellImage.frame = self.cellFrameInSuperview;
    [self.selectedCellImage setImage:image];
    self.cellFrameInPreviewView = CGRectMake(0, -65, [UIScreen mainScreen].bounds.size.width, 300);
    self.whiteView.alpha = 0;
}


#pragma mark - CollectionCellDelegate

- (void)selectEvent:(NSString*)eventId :(CGRect)attributes :(UIImage*)image
{
    NSIndexPath* indexPathForTheFirstCell = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewLayoutAttributes *attributesForTheFirstCell = [self.collectionView layoutAttributesForItemAtIndexPath:indexPathForTheFirstCell];
    CGRect cellRect = attributesForTheFirstCell.frame;
    self.colelctionCellFrameInSuperview = [self.collectionView convertRect:cellRect toView:[self.collectionView superview]];
    CGRect frameRect = attributes;
    frameRect.origin.y = self.colelctionCellFrameInSuperview.origin.y;
    attributes = frameRect;
    [self selectingCell:attributes :image];
    
    [UIView animateWithDuration:0.5 animations:^{
        self.navigationController.navigationBar.alpha = 0;
        self.whiteView.alpha = 1;
        self.selectedCellImage.frame = self.cellFrameInPreviewView;
        
    } completion:^(BOOL finished) {

    FREventPreviewController* vc = [[FREventPreviewController alloc] initWithEventId:eventId];
        vc.delegate = self;
    [self presentViewController:vc animated:NO completion:^{}];
    }];
}

- (void)moveBackAndShowVC
{
    self.selectedCellImage.frame = self.cellFrameInPreviewView;

    [UIView animateWithDuration:0.5 animations:^{
     
        self.selectedCellImage.frame = self.cellFrameInSuperview;
        self.whiteView.alpha = 0;

    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            self.selectedCellImage.alpha = 0;
            self.navigationController.navigationBar.alpha = 1;
        }];
    }];
}
@end
