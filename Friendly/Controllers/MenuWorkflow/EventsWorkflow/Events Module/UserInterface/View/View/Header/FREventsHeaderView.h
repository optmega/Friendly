//
//  FREventsHeaderView.h
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FRSegmentView;

#import "FREventsHeaderViewModel.h"

@interface FREventsHeaderView : UIView
@property (nonatomic, strong) UISearchBar* searchBar;
@property (nonatomic, strong) UIButton* filterButton;
@property (nonatomic, strong) UIButton* faceButton;

@property (nonatomic, strong) FRSegmentView* segmentView;

- (void)updateAlpha:(CGFloat)alpha;
- (void)updateModel:(FREventsHeaderViewModel*)model;
- (void)reloadData;
@end
