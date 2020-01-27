//
//  FRGenderInputeView.h
//  Friendly
//
//  Created by Sergey Borichev on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventBaseInpute.h"

@protocol FRGenderInputeViewDelegate <NSObject>

- (void)selectedGender:(FRGenderType)gender;
- (void)closeSelected;

@end

@interface FRGenderInputeView : FRCreateEventBaseInpute

@property (nonatomic, weak) id<FRGenderInputeViewDelegate>delegate;

- (void)setGender:(FRGenderType)type;


@end
