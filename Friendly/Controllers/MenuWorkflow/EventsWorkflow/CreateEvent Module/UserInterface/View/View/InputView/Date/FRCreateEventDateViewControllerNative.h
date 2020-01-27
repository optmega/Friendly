//
//  FRCreateEventDateViewControllerNative.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRCreateEventDateViewControllerNativeDelegate <NSObject>

- (void)selectedDate:(NSDate*)date;

@end

@interface FRCreateEventDateViewControllerNative : FRVCWithOpacity

@property (nonatomic, strong) NSDate* eventDate;
@property (nonatomic, strong) UIDatePicker* datePicker;
@property (weak, nonatomic) id<FRCreateEventDateViewControllerNativeDelegate>delegate;

@end
