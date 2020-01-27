//
//  FRMyEventsSegmentedMenuButton.m
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsSegmentedMenuButton.h"

@implementation FRMyEventsSegmentedMenuButton

-(instancetype) init
{
    self = [super init];
    if (self)
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.titleLabel.font = FONT_SF_DISPLAY_MEDIUM(15);
    }
    return self;
}

@end
