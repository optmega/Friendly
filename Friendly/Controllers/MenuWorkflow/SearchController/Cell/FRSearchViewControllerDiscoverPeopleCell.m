//
//  FRSearchViewControllerDiscoverPeopleCell.m
//  Friendly
//
//  Created by Jane Doe on 4/21/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchViewControllerDiscoverPeopleCell.h"
#import "FRStyleKit.h"
#import "FRSearchViewControllerDiscoverPeopleCollectionCell.h"
#import "FRSearchUserModel.h"
#import "FRSearchViewControllerDiscoverPeopleView.h"

@interface FRSearchViewControllerDiscoverPeopleCell()  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>


@property (strong, nonatomic) UILabel* titleLabel;
@property (strong, nonatomic) UILabel* subtitleLabel;
@property (strong, nonatomic) UICollectionView* peopleCollection;
@property (strong, nonatomic) UIImageView* arrow;
@property (strong, nonatomic) UIView* separator;
@property (strong, nonatomic) UICollectionView* attendingCollectionView;
@property (strong, nonatomic) FRSearchViewControllerDiscoverPeopleView* peopleView;
@property (strong, nonatomic) NSArray* users;

@end

static NSString* const kUserCell = @"kUserCell";


@implementation FRSearchViewControllerDiscoverPeopleCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self separator];
        [self titleLabel];
        [self subtitleLabel];
        [self peopleCollection];
        [self arrow];
//        [self attendingCollectionView];
//        self.attendingCollectionView.transform = CGAffineTransformMake(1, 0, 0, -1, 0, 0);
        [self peopleView];
            }
    return self;
}

-(void)updateWithUsers:(NSArray *)users
{
    self.users = users;
    [self.titleLabel setText:[NSString stringWithFormat:@"Discover %lu people", (unsigned long)users.count]];

    [self.peopleView updateWithUsers:users];
    if (users.count == 0) {
        self.peopleView.hidden = YES;
        self.titleLabel.hidden = YES;
        self.subtitleLabel.hidden = YES;
        self.arrow.hidden = YES;
    }
    else
    {
        self.peopleView.hidden = NO;
        self.titleLabel.hidden = NO;
        self.subtitleLabel.hidden = NO;
        self.arrow.hidden = NO;
    }
//    [self.attendingCollectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.users.count<3)
    {
    return self.users.count;
    }
    else
    {
    return 3;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    FRSearchViewControllerDiscoverPeopleCollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUserCell forIndexPath:indexPath];
    FRSearchUserModel* userModel = [self.users objectAtIndex:indexPath.row];
   [cell updateWithPhoto:userModel.photo];
    cell.transform = collectionView.transform;
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView;
{
    return 1;
}


#pragma mark - LazyLoad

-(UILabel*) titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [UILabel new];
        [_titleLabel setTextColor:[UIColor bs_colorWithHexString:kTitleColor]];
        [_titleLabel setFont:FONT_SF_DISPLAY_MEDIUM(20)];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(10);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.attendingCollectionView.mas_left);
        }];
    }
    return _titleLabel;
}

-(UILabel*) subtitleLabel
{
    if (!_subtitleLabel)
    {
        _subtitleLabel = [UILabel new];
        [_subtitleLabel setText:@"With this tag in their profile"];
        [_subtitleLabel setTextColor:[UIColor bs_colorWithHexString:@"9CA0AB"]];
        [_subtitleLabel setFont:FONT_SF_DISPLAY_REGULAR(14)];
        [_subtitleLabel sizeToFit];
        _subtitleLabel.adjustsFontSizeToFitWidth = YES;
        [self.contentView addSubview:_subtitleLabel];
        [_subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.titleLabel.mas_bottom).offset(3);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView.mas_centerX);
        }];
        
    }
    return _subtitleLabel;
}

-(UIView*) separator
{
    if (!_separator)
    {
        _separator = [UIView new];
        _separator.layer.cornerRadius = 2;
        _separator.backgroundColor = [UIColor bs_colorWithHexString:kSeparatorColor];
        [self.contentView addSubview:_separator];
        [_separator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.height.equalTo(@1);
        }];
    }
    return _separator;
}

-(UIImageView*) arrow
{
    if (!_arrow)
    {
        _arrow = [UIImageView new];
        [_arrow setBackgroundColor:[UIColor clearColor]];
        [_arrow setImage:[FRStyleKit imageOfFeildChevroneCanvas]];
        [self.contentView addSubview:_arrow];
        [_arrow mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15);
            make.height.width.equalTo(@15);
            make.centerY.equalTo(self.contentView);
        }];
    }
    return _arrow;
}

- (UICollectionView*) attendingCollectionView
{
    if (!_attendingCollectionView)
    {
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        _attendingCollectionView=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _attendingCollectionView.showsHorizontalScrollIndicator = NO;
            [layout setMinimumInteritemSpacing:-20];
        _attendingCollectionView.bounces = NO;
        [_attendingCollectionView setTransform:CGAffineTransformMakeScale(-1, 1)];
        [_attendingCollectionView registerClass:[FRSearchViewControllerDiscoverPeopleCollectionCell class] forCellWithReuseIdentifier:kUserCell];
//        _attendingCollectionView.layer.drawsAsynchronously = YES;
        [_attendingCollectionView setDataSource:self];
        [_attendingCollectionView setDelegate:self];
        
        [_attendingCollectionView setBackgroundColor:[UIColor clearColor]];
        
        [self.contentView addSubview:_attendingCollectionView];
        
        [_attendingCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {

            make.right.equalTo(self.arrow.mas_left).offset(-3);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
        }];
    }
    return _attendingCollectionView;
}

-(FRSearchViewControllerDiscoverPeopleView*)peopleView
{
    if (!_peopleView)
    {
        _peopleView = [FRSearchViewControllerDiscoverPeopleView new];
        [self.contentView addSubview:_peopleView];
        [_peopleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.arrow.mas_left).offset(-3);
            make.width.equalTo(@120);
            make.bottom.equalTo(self.contentView).offset(-10);
            make.top.equalTo(self.contentView).offset(10);
        }];
    }
    return _peopleView;
}
@end
