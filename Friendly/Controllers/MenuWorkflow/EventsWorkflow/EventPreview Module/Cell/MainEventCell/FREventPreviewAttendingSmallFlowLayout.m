//
//  FREventPreviewAttendingSmallFlowLayout.m
//  Friendly
//
//  Created by Jane Doe on 3/14/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventPreviewAttendingSmallFlowLayout.h"

@implementation FREventPreviewAttendingSmallFlowLayout



- (CGSize)collectionViewContentSize
{
    
    return [super collectionViewContentSize];
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return [super layoutAttributesForElementsInRect:rect];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSLog(@"MZMCollectionViewFlowLayout layoutAttributesForItemAtIndexPath");
    if (indexPath.section == 0 && indexPath.row == 1) // or whatever specific item you're trying to override
    {
        UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        layoutAttributes.frame = CGRectMake(0,0,28,28); // or whatever...
        return layoutAttributes;
    }
    else
    {
        return [super layoutAttributesForItemAtIndexPath:indexPath];
    }
}

@end
