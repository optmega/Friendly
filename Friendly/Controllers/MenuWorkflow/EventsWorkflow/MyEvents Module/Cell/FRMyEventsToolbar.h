//
//  FRMyEventsToolbar.h
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRMyEventsToolbarDelegate <NSObject>

- (void)showSearch;
- (void)showEventRequests;

@end

@interface FRMyEventsToolbar : UIToolbar

@property (nonatomic, weak) id <FRMyEventsToolbarDelegate> delegate;
- (void) updateBadgeWithCount:(NSInteger)count;
- (void) updateAvatarPhoto;
@end
