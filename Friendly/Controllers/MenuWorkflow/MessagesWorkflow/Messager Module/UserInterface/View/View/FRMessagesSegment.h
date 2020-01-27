//
//  FRMessagesSegment.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


typedef NS_ENUM(NSInteger, FRMessagesSegmentType) {
    FRMessagesSegmentTypeMessages = 0,
    FRMessagesSegmentTypeFriends,
};


@protocol FRMessagesSegmentDelegate <NSObject>

- (void)selectedSegmentIndex:(FRMessagesSegmentType)index;

@end

@interface FRMessagesSegment : UIView

@property (nonatomic, weak) id<FRMessagesSegmentDelegate> delegate;

@end
