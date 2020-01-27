//
//  FREventListCell.m
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventListCell.h"
#import "FREventCollectionCell.h"
#import "FREventModel.h"


@interface FREventListCell() <UICollectionViewDelegate, UICollectionViewDataSource, FREventCollectionCellViewModelDelegate>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* list;
@property (nonatomic, assign) CGRect cellFrameInSuperview;
@property (nonatomic, strong) FREventListCellViewModel* model;

@end


static NSString* const kCellId = @"kCellId";

@implementation FREventListCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      [self collectionView];
    }
    return self;
}


- (void)updateWithModel:(FREventListCellViewModel*)model
{
    self.model = model;
    self.list = [self _viewModelsFromModels:model.list];
    [self.collectionView reloadData];
}

- (NSArray*)_viewModelsFromModels:(NSArray*)list
{
    NSMutableArray* viewModels = [NSMutableArray array];

    [list enumerateObjectsUsingBlock:^(FREventModel* _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        FREventCollectionCellViewModel* viewModel = [FREventCollectionCellViewModel initWithModel:obj];
        viewModel.delegate = self;
        [viewModels addObject:viewModel];
    }];
    
    return viewModels;
}



#pragma mark - FREventCollectionCellViewModelDelegate

- (void)pressUserPhoto:(NSString*)userId
{
    [self.model pressUserPhoto:userId];
}

- (void)pressJoinEventId:(NSString*)eventId andModel:(FREvent *)event
{
    [self.model pressJoinEventId:eventId andModel:event];
}

- (void)selectedShareEvent:(FREvent *)event
{
    [self.model selectedShareEvent:event];
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.list.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventCollectionCell* eventCell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellId forIndexPath:indexPath];
    [eventCell updateViewModel:[self.list objectAtIndex:indexPath.row]];
    eventCell.layer.cornerRadius = 5;
    eventCell.clipsToBounds = YES;
    
    return eventCell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scroll withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSUInteger nearestIndex = (NSUInteger)(targetContentOffset->x / self.collectionView.bounds.size.width );
    CGFloat xOffset = nearestIndex * self.collectionView.bounds.size.width;
    xOffset = xOffset == 0 ? 1 : (xOffset - 15 * nearestIndex);
    if (targetContentOffset->x + scroll.bounds.size.width >= scroll.contentSize.width)
    {
        xOffset = scroll.contentSize.width;
    }
    *targetContentOffset = CGPointMake(xOffset, targetContentOffset->y);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if( !decelerate )
    {
        NSUInteger currentIndex = (NSUInteger)(scrollView.contentOffset.x / scrollView.bounds.size.width);
        [scrollView setContentOffset:CGPointMake(scrollView.bounds.size.width * currentIndex, 0) animated:YES];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    
    self.cellFrameInSuperview = [collectionView convertRect:cellRect toView:[collectionView superview]];
    CGRect frameRect = self.cellFrameInSuperview;
    frameRect.origin.y = self.cellFrameInSuperview.origin.y + 55;
    self.cellFrameInSuperview = frameRect;
    
    FREventCollectionCell* item = (FREventCollectionCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView* eventImage = item.eventImage;
    
    FREventCollectionCellViewModel* event = [self.list objectAtIndex:indexPath.row];
    [self.delegate selectEvent:[event domainModel] frame:self.cellFrameInSuperview image:eventImage.image] ;
}


#pragma mark - Lazy Load

- (UICollectionView*)collectionView
{
    if (!_collectionView)
    {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        
        [flowLayout setItemSize:CGSizeMake(width - 25, 315)];
        [flowLayout setMinimumInteritemSpacing:10.f];
        [flowLayout setMinimumLineSpacing:10.f];
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 5, 10, 5)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor bs_colorWithHexString:@"#E8EBF1"];
        [_collectionView registerClass:[FREventCollectionCell class] forCellWithReuseIdentifier:kCellId];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.showsVerticalScrollIndicator = NO;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.right.equalTo(self.contentView);
            make.top.equalTo(self.contentView).offset(0);
        
        }];
    }
    return _collectionView;
}

@end
