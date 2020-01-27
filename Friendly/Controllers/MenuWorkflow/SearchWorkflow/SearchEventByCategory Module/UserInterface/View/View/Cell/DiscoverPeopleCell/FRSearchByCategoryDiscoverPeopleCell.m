//
//  FRSearchByCategoryDiscoverPeopleCell.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryDiscoverPeopleCell.h"

@implementation FRSearchByCategoryDiscoverPeopleCell

- (void)updateWithModel:(FRSearchByCategoryDiscoverPeopleCellViewModel*)model
{
    [self updateWithUsers:[model users]];
}

@end
