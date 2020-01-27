//
//  FRSearchByCategoryDiscoverPeopleCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryDiscoverPeopleCellViewModel.h"

@implementation FRSearchByCategoryDiscoverPeopleCellViewModel

- (CGFloat)heightCell
{
    if (self.users.count == 0)
    {
        return 0;
    }
    else
    {
        return 70;
    }
}

@end
