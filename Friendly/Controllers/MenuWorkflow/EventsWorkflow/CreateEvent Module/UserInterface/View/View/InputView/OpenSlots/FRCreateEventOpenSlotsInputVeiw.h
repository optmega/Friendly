//
//  FRCreateEventOpenSlotsInputVeiw.h
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventBaseInpute.h"

@protocol FRCreateEventOpenSlotsInputVeiwDelegate <NSObject>

- (void)slotsUpdate:(NSInteger)slots;
- (void)closeSelected;

@end

@interface FRCreateEventOpenSlotsInputVeiw : FRCreateEventBaseInpute


@property (nonatomic, weak) id<FRCreateEventOpenSlotsInputVeiwDelegate>delegate;
- (void)updateUpperValue:(NSInteger)upperValue;

@end
