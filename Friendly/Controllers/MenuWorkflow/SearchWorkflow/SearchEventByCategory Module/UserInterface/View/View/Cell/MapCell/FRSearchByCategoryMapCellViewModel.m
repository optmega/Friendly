//
//  FRSearchByCategoryMapCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRSearchByCategoryMapCellViewModel.h"

@interface FRSearchByCategoryMapCellViewModel ()

@end

@implementation FRSearchByCategoryMapCellViewModel

- (CGFloat)heightCell
{
    if (self.markersArray.count <= 1)
    {
        return 0;
    }
    else
    {
        return self.isSelected ? 400 : 125;
    }
}

- (void)pressShowFullScreen:(BOOL)isSelected
{
    self.isSelected = isSelected;
    [self.delegate selectedShowFullScreen];
}

- (void)showEventPreviewWithEvent:(FREvent*)event
{
    [self.delegate showEventPreviewWithEvent:event];
}

- (void)showUserProfile:(UserEntity *)user {
    [self.delegate showUserProfile:user];
}
@end
