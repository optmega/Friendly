//
//  FRMyEventsSegmentedMenu.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FRMyEventsSegmentedMenuDelegate <NSObject>

- (void) selectedHosting;
- (void) selectedJoining;

@end

@interface FRMyEventsSegmentedMenu : UIView

@property (weak, nonatomic) id<FRMyEventsSegmentedMenuDelegate>delegate;

@end
