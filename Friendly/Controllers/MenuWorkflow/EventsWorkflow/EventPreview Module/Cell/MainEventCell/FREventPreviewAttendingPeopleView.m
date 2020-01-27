//
//  AttendingPeopleView.m
//  Project
//
//  Created by Zaslavskaya Yevheniya on 01.03.16.
//  Copyright © 2016 Jane Doe. All rights reserved.
//

#import "FREventPreviewAttendingPeopleView.h"
#import "FREventPreviewEventViewCellViewModel.h"
#import "UIImageView+AFNetworking.h"
#import "FREventPreviewAttendingSmallCollectionCell.h"


@interface FREventPreviewAttendingPeopleView() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UIImageView* avatar1;
@property (strong, nonatomic) UIImageView* avatar2;
@property (strong, nonatomic) UIImageView* avatar3;
@property (strong, nonatomic) UIImageView* avatar4;
//@property (strong, nonatomic) UIImageView* avatar5;
//@property (strong, nonatomic) UIButton* moreButton;
@property (strong, nonatomic) NSArray* users;
@property (strong, nonatomic) UICollectionView* smallAttendingCollectionView;
@property (strong, nonatomic) UIButton* openButton;
@property (strong, nonatomic) FREventPreviewEventViewCellViewModel* model;


@end

@implementation FREventPreviewAttendingPeopleView

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
//        [self avatar1];
//        [self avatar2];
//        [self avatar3];
//        [self avatar4];
        //[self avatar5];
       // [self moreButton];
       [self smallAttendingCollectionView];
        [self openButton];
    }
    return self;
}

- (void) updateWithModel:(FREventPreviewEventViewCellViewModel*)model
{
 self.model = model;
[self.smallAttendingCollectionView reloadData];

}

//

#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section==0)
    {
        if (self.model.users.count>=4)
        {
            return 4;
        }
        else
        {
            return self.model.users.count-1;
        }
    }
    else
        return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventPreviewAttendingSmallCollectionCell *cell=(FREventPreviewAttendingSmallCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell updateWithModel:[self.model.users objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    return cell;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return -5.0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(28, 28);
}


#pragma mark - LazyLoad

- (UICollectionView*) smallAttendingCollectionView
{
    if (!_smallAttendingCollectionView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _smallAttendingCollectionView=[[UICollectionView alloc] initWithFrame:self.frame collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        [layout setMinimumInteritemSpacing:-5];
        [_smallAttendingCollectionView registerClass:[FREventPreviewAttendingSmallCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [_smallAttendingCollectionView setDataSource:self];
        [_smallAttendingCollectionView setDelegate:self];
        
        [_smallAttendingCollectionView setBackgroundColor:[UIColor clearColor]];
        
        [self addSubview:_smallAttendingCollectionView];
        
        [_smallAttendingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return _smallAttendingCollectionView;
}

- (UIButton*) openButton
{
    if (!_openButton)
    {
        _openButton = [UIButton new];
        [_openButton setTitle:@"2 Open" forState:(UIControlStateNormal)];
        [_openButton setTitleColor:[UIColor bs_colorWithHexString:@"969BA7"] forState:UIControlStateNormal];
        [_openButton setBackgroundColor:[UIColor clearColor]];
        _openButton.layer.borderColor = [[UIColor bs_colorWithHexString:@"E8EBF1"] CGColor];
        _openButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _openButton.layer.borderWidth = 1;
        _openButton.layer.cornerRadius = 8;
        [self addSubview:_openButton];
        [_openButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.smallAttendingCollectionView.mas_right).offset(5);
            make.centerY.equalTo(self);
            make.height.equalTo(@20);
            make.width.equalTo(@50);
        }];
    }
    return _openButton;
}


@end
