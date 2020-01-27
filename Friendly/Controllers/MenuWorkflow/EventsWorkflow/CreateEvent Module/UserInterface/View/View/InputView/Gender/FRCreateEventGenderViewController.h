//
//  FRCreateEventGenderViewController.h
//  Friendly
//
//  Created by Jane Doe on 4/1/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"

@protocol FRCreateEventGenderViewControllerDelegate <NSObject>

- (void)selectedGender:(FRGenderType)gender;

@end


@interface FRCreateEventGenderViewController : FRVCWithOpacity

@property (nonatomic, weak) id<FRCreateEventGenderViewControllerDelegate>delegate;
@property (nonatomic, assign) FRGenderType genderType;

@end
