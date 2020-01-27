//
//  FRCategoryManager.m
//  Friendly
//
//  Created by Jane Doe on 5/19/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCategoryManager.h"

@implementation FRCategoryManager

+(NSDictionary*)getCategoryDictionary
{
    return @{    @"All" : @"0",
             @"Popular" : @"1",
             @"Friends" : @"2",
       @"Fitness/sport" : @"3",
            @"Outdoors" : @"4",
             @"Dining" : @"5",
               @"Party" : @"6",
             @"Animals" : @"7",
            @"Business" : @"8",
               @"Other" : @"9",
             @"Weekend" : @"10",
         @"Ending soon" : @"11",
           @"Nightlife" : @"12",
              @"Travel" : @"13",
           @"Community" : @"14",
             @"Fitness" : @"15",
                @"Pets" : @"16",
               @"Sport" : @"17",
                 @"Gay" : @"18",
              @"Geekon" : @"19",
                 @"Fun" : @"20",
             @"Nearest" : @"21",
             };
}

@end
