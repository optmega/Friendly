//
//  FRAttendingTableViewCell.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewAttendingCell.h"
#import "FREventPreviewAttendingCollectionCell.h"

@interface FREventPreviewAttendingCell() <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, FREventPreviewAttendingCollectionCellDelegate>

@property (strong, nonatomic) UILabel* title;
@property (strong, nonatomic) UICollectionView* attendingCollectionView;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) FREventPreviewAttendingViewModel* model;

@end

@implementation FREventPreviewAttendingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self title];
        [self attendingCollectionView];
        self.attendingCollectionView.pagingEnabled = YES;
        [self separator];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


- (void) updateWithModel:(FREventPreviewAttendingViewModel*)model
{
    self.model = model;
    [self.attendingCollectionView reloadData];
}

-(void)showUserProfile:(NSString *)userId
{
//    if ((![userId isEqualToString:[FRUserManager sharedInstance].currentUser.user_id])||(![userId isEqualToString:self.model.partnerId]))
//    {
    [self.delegate attendingUserTaped:userId];

}


#pragma mark - CollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.model.users.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FREventPreviewAttendingCollectionCell *cell=(FREventPreviewAttendingCollectionCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell updateWithModel:[self.model.users objectAtIndex:indexPath.row]];
    cell.backgroundColor=[UIColor clearColor];
    cell.delegate = self;
    return cell;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(70, 90);
}


#pragma mark - LazyLoad

- (UICollectionView*) attendingCollectionView
{
    if (!_attendingCollectionView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _attendingCollectionView=[[UICollectionView alloc] initWithFrame:self.contentView.frame collectionViewLayout:layout];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
      [_attendingCollectionView registerClass:[FREventPreviewAttendingCollectionCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
        
        [_attendingCollectionView setDataSource:self];
        [_attendingCollectionView setDelegate:self];
        
        [_attendingCollectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_attendingCollectionView];
        
        [_attendingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.title.mas_bottom).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView).offset(-20);
        }];
    }
    return _attendingCollectionView;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:@"E6E8EC"];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(40);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UILabel*) title
{
    if (!_title)
    {
        _title = [UILabel new];
        [_title setTextColor:[UIColor bs_colorWithHexString:@"263345"]];
        [_title setText:@"Attending"];
        [_title setFont:FONT_SF_DISPLAY_MEDIUM(20)];
        [self.contentView addSubview:_title];
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.separator).offset(35);
            make.left.equalTo(self.contentView).offset(15);
        }];
    }
    return _title;
}

@end

