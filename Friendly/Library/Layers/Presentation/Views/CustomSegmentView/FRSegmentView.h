//
//  FRSegmentView.h
//  Friendly
//
//  Created by Sergey Borichev on 01.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


typedef NS_ENUM(NSInteger, FRSegmentType) {
    FRSegmentTypeFeatured = 0,
    FRSegmentTypeNearby,
    FRSegmentTypeFriends,
};

@protocol FRSegmentViewDelegate <NSObject>

- (void)selectedSegmentIndex:(FRSegmentType)index;

@end

@interface FRSegmentView : UIView

@property (nonatomic, weak) id<FRSegmentViewDelegate> delegate;

@end
