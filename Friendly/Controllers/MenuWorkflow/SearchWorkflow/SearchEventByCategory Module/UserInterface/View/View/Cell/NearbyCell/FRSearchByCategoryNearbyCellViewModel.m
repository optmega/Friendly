//
//  FRSearchByCategoryNearbyCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryNearbyCellViewModel.h"

@implementation FRSearchByCategoryNearbyCellViewModel

- (NSString*)content
{
    return [NSString stringWithFormat:@"%ld NEARBY", (long)self.count];
}

- (void)settingSelected
{
    [self.delegate settingSelected];
}

@end
