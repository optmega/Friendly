//
//  FRRecommendedUserHeaderView.h
//  Friendly
//
//  Created by Sergey Borichev on 03.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol FRRecommendedUserHeaderViewDelegate <NSObject>

- (void)backSelected;

@end

@interface FRRecommendedUserHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<FRRecommendedUserHeaderViewDelegate> delegate;

@property (nonatomic, strong) UIButton* backButton;

- (void)updateTitleFrameWithOffset:(CGPoint)point;

@end
