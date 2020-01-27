//
//  FREventFilterSelectDateViewController.h
//  Friendly
//
//  Created by User on 13.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"


@protocol FREventFilterSelectDateViewControllerDelegate <NSObject>

- (void)selectedDate:(FRDateFilterType)type andText:(NSString*)text;

@end

@interface FREventFilterSelectDateViewController : FRVCWithOpacity

@property (weak, nonatomic) id<FREventFilterSelectDateViewControllerDelegate> delegate;

@end
