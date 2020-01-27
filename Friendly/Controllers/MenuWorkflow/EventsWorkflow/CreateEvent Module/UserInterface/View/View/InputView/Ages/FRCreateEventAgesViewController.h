//
//  FRCreateEventAgesViewController.h
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRCreateEventAgesViewControllerDelegate <NSObject>

- (void)updateAgesMin:(NSInteger)min max:(NSInteger)max;
- (void)selectedWrongRange;

@end

@interface FRCreateEventAgesViewController : FRVCWithOpacity

- (void)setAgeMin:(CGFloat)min max:(CGFloat)max;

@property (nonatomic, weak) id<FRCreateEventAgesViewControllerDelegate>delegate;

@end
