//
//  FRCreateEventTimeViewControllerNative.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRCreateEventTimeViewControllerNativeDelegate <NSObject>

- (void)didSelectTime:(NSDate*)time;

@end

@interface FRCreateEventTimeViewControllerNative : FRVCWithOpacity

@property (nonatomic, strong) NSDate* eventTime;
@property (nonatomic, strong) UIDatePicker* timePicker;
@property (weak, nonatomic) id<FRCreateEventTimeViewControllerNativeDelegate>delegate;

@end
