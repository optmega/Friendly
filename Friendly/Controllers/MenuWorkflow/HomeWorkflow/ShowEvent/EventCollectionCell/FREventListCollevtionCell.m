//
//  FREventCollevtionCell.m
//  Friendly
//
//  Created by Sergey Borichev on 15.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventListCollevtionCell.h"
#import "FREventCollectionCell.h"
#import "FREventModel.h"

@interface FREventListCollevtionCell () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView* collectionView;
@property (nonatomic, strong) NSArray* list;
@property (nonatomic, assign) CGRect cellFrameInSuperview;


@end

static NSString* const kCellId = @"kCellId";

@implementation FREventListCollevtionCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self collectionView];
    }
    return self;
}

- (void)updateWithModel:(NSArray*)array
{
    self.list = array;
    [self.collectionView reloadData];
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
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 5, 10, 5)];
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionView.backgroundColor = [UIColor bs_colorWithHexString:@"#E8EBF1"];
        [_collectionView registerClass:[FREventCollectionCell class] forCellWithReuseIdentifier:kCellId];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [self.contentView addSubview:_collectionView];
        
        [_collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _collectionView;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [collectionView layoutAttributesForItemAtIndexPath:indexPath];
    CGRect cellRect = attributes.frame;
    
    self.cellFrameInSuperview = [collectionView convertRect:cellRect toView:[collectionView superview]];
    CGRect frameRect = self.cellFrameInSuperview;
    frameRect.origin.y = self.cellFrameInSuperview.origin.y + 55;
    self.cellFrameInSuperview = frameRect;
    
    FREventModel* event = [self.list objectAtIndex:indexPath.row];
    [self.delegate selectEvent:event :self.cellFrameInSuperview :[UIImage imageNamed:@"imageEvent"]];
}

@end
