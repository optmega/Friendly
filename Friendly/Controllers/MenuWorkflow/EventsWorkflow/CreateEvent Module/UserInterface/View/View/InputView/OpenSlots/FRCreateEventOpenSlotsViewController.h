//
//  FRCreateEventOpenSlotsViewController.h
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRCreateEventOpenSlotsViewControllerDelegate <NSObject>

- (void)slotsUpdate:(NSInteger)slots;

@end

@interface FRCreateEventOpenSlotsViewController : FRVCWithOpacity

@property (nonatomic, weak) id<FRCreateEventOpenSlotsViewControllerDelegate>delegate;
@property (nonatomic, assign) NSInteger slotsCount;

@end
