//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersController.h"
#import "FRRecommendedUsersDataSource.h"
#import "FRRecommendedUsersCell.h"
#import "FRRecommendedUserHeaderView.h"

@interface FRRecommendedUsersController () <FRRecommendedUserHeaderViewDelegate>

@property (nonatomic, strong) FRRecommendedUserHeaderView* headerView;
@property (nonatomic, assign) CGFloat lastOffset;

@property (nonatomic, assign) CGFloat lastOffsetY;
@property (nonatomic, assign) CGFloat heightInset;
@property (nonatomic, assign) CGFloat screenHeight;

@end

static CGFloat const kHeaderSectionHeight = 110;


@implementation FRRecommendedUsersController

- (instancetype)initWithTableView:(UITableView *)tableView
{
    self = [super initWithTableView:tableView];
    if (self)
    {
        [self registerCellClass:[FRRecommendedUsersCell class] forModelClass:[FRRecommendedUsersCellViewModel class]];
        [self.tableView registerClass:[FRRecommendedUserHeaderView class] forHeaderFooterViewReuseIdentifier:@"FRRecommendedUserHeaderView"];
        self.tableView.rowHeight = 70;
    }
    return self;
}


- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{
    [self.scrollDelegate changePositionY:scrollView.contentOffset.y];

    return;
//    [self.headerView updateTitleFrameWithOffset:scrollView.contentOffset];
//    
//    if (self.tableView.contentSize.height < self.screenHeight)
//    {
//        return;
//    }
//    
//    CGFloat sectionHeaderHeight = kHeaderSectionHeight;
//    
//    if ((scrollView.contentOffset.y + scrollView.bounds.size.height) >= scrollView.contentSize.height || scrollView.contentOffset.y <= 0)
//    {
//        return;
//    }
//    
//    if (scrollView.contentOffset.y <= kHeaderSectionHeight && (self.heightInset < 0))
//    {
//        self.heightInset += (self.lastOffsetY - scrollView.contentOffset.y);
//        self.heightInset = self.heightInset > 0 ? 0 : self.heightInset;
//        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset, 0, 0, 0);
//        
//            CGRect frame = self.headerView.backButton.frame;
//            frame.origin.y = 30 - self.heightInset;
//            self.headerView.backButton.frame = frame;
//    }
//    
//    else if (self.lastOffsetY < scrollView.contentOffset.y && (self.heightInset >= - sectionHeaderHeight))
//    {
//        self.heightInset -= (scrollView.contentOffset.y - self.lastOffsetY );
//        self.heightInset = self.heightInset < -sectionHeaderHeight ? -sectionHeaderHeight : self.heightInset;
//        scrollView.contentInset = UIEdgeInsetsMake(self.heightInset, 0, 0, 0);
//        
//        CGRect frame = self.headerView.backButton.frame;
//        frame.origin.y = 30 - self.heightInset;
//        self.headerView.backButton.frame = frame;
//    }
//    
//    self.lastOffsetY = scrollView.contentOffset.y;
    //    [self.recommendedScrollDeletage tableScrollViewDidScroll:scrollView];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    self.headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"FRRecommendedUserHeaderView"];
    self.headerView.delegate = self;
    return self.headerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)updateDataSource:(FRRecommendedUsersDataSource *)dataSource
{
    self.storage = dataSource.storage;
}


#pragma mark - FRRecommendedUserHeaderViewDelegate

- (void)backSelected
{
    [self.recommendedScrollDeletage backSelected];
}


@end
