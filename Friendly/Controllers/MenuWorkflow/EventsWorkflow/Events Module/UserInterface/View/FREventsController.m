//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventsController.h"
#import "FREventsDataSource.h"
#import "FREventsCell.h"
#import "FREventListCell.h"
#import "FREventsHeaderView.h"
#import "FREventsHeaderViewModel.h"
#import "FREventsCellViewModel.h"
#import "FRUserModel.h"
#import "FREventModel.h"
#import "FRFriendsCell.h"
#import "FRAdvertisementCell.h"
#import "FRSegmentView.h"


@interface FREventsController () <FREventsHeaderViewModelDelegate, FREventListCollevtionCellDelegate>

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;
@property (nonatomic, assign) BOOL isCVCell;
@property (nonatomic, strong) UIImageView* selectedCellImage;
@property (nonatomic, assign) CGFloat screenHeight;

@end

static CGFloat const kHeaderSectionHeight = 44;
static CGFloat const kCellHeight = 235;

@implementation FREventsController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FREventsCell class] forModelClass:[FREventsCellViewModel class]];
        [self registerCellClass:[FREventListCell class] forModelClass:[FREventListCellViewModel class]];
        
        [self registerCellClass:[FRAdvertisementCell class] forModelClass:[FRAdvertisementCellViewModel class]];
        
        self.screenHeight = [UIScreen mainScreen].bounds.size.height;
        self.addAnimation = UITableViewRowAnimationNone;
        self.tableView.bounces = YES;
    }
    return self;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && [cell isKindOfClass:[FREventListCell class]])
    {
        FREventListCell* cellList = (FREventListCell*)cell;
        cellList.delegate = self;
    }
    
    if ([cell isKindOfClass:[FRAdvertisementCell class]])
    {
//        DFPBannerView* banner = [self.delegate bannerView];
        
//        [cell.contentView addSubview:banner];
//        banner.center = cell.contentView.center;
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.tableView.contentSize.height < self.screenHeight)
    {
        [self.delegate updateHeaderViewForPosition:0 opacity:1];
        return;
    }
    
    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
    
    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) >= scrollView.contentSize.height || scrollView.contentOffset.y <= 0)
    {
        return;
    }
    
    if (self.lastOffsetY > scrollView.contentOffset.y && (self.heightInset < 0))
    {
        self.heightInset += (self.lastOffsetY - scrollView.contentOffset.y);
        self.heightInset = self.heightInset > 0 ? 0 : self.heightInset;
    }
    
    else if (self.lastOffsetY < scrollView.contentOffset.y && (self.heightInset >= - sectionHeaderHeight))
    {
        self.heightInset -= (scrollView.contentOffset.y - self.lastOffsetY );
        self.heightInset = self.heightInset < -sectionHeaderHeight ? -sectionHeaderHeight : self.heightInset;
    }
    
    CGFloat opacity = (44. + self.heightInset) / 44.;
    
    if (-scrollView.contentInset.top >= 2 )
    {
        opacity /= 1.414;
    }
    
    [self.delegate updateHeaderViewForPosition:self.heightInset opacity:opacity];
    self.lastOffsetY = scrollView.contentOffset.y;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    
    id item = [storage itemAtIndexPath:indexPath];
    
    if ([item isKindOfClass:[FREventListCellViewModel class]])
    {
        return 325;
    }
    
    if ([item isKindOfClass:[FRAdvertisementCellViewModel class]])
    {
        return 300;
    }
    
    
    return kCellHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    BSMemoryStorage* storage = (BSMemoryStorage*)self.storage;
    
    id item = [storage itemAtIndexPath:indexPath];
    if (![item isKindOfClass:[FREventsCellViewModel class]])
    {
        return;
    }
    
//    FREventsCellViewModel* event = [storage.storageArray objectAtIndex:indexPath.row];
    self.isCVCell = NO;
    
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    CGRect cellRect = cell.frame;
//    CGRect cellFrameInSuperview = [tableView convertRect:cellRect toView:[tableView superview]];
//    
//    FREvent* ev = [event domainModel];
//    UIImageView* imageView = [(FREventsCell*)cell eventImage];
    
//    [self.delegate selectingCell:cellFrameInSuperview image:imageView.image event:ev firstCell:NO];
}

- (void)updateDataSource:(FREventsDataSource *)dataSource
{
    self.storage = dataSource.storage;
}


#pragma mark - FREventListCollevtionCellDelegate

- (void)selectEvent:(FREventModel*)event frame:(CGRect)attributes image:(UIImage*)image
{
    
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    CGRect cellRect = cell.frame;
    CGRect colelctionCellFrameInSuperview = [self.tableView convertRect:cellRect toView:[self.tableView superview]];
    CGRect frameRect = attributes;
    
    frameRect.origin.y = colelctionCellFrameInSuperview.origin.y;
    attributes = frameRect;
    
    [self.delegate selectingCell:frameRect image:image event:event firstCell:YES];
}



#pragma mark - FREventsHeaderViewModelDelegate

- (void)showShowUserProfileSelected
{
    [self.delegate showShowUserProfileSelected];
}

- (void)showFilterSelected
{
    [self.delegate showFilter];
}

- (void)dealloc
{
    
}
@end
