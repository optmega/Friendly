//
//  BSMemoryStorage.m
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSMemoryStorage.h"

@implementation BSMemoryStorage


+ (instancetype)storage
{
    BSMemoryStorage* memoryStorage = [BSMemoryStorage new];
    return memoryStorage;
}

- (void)scrollToTop
{
    [self.delegate scrollToTop];
}




#pragma mark - Add supplimentary

- (void)addFooter:(id)footer forSection:(NSInteger)section
{
    
}

- (void)addHeader:(id)header forSection:(NSInteger)section
{
    
}



#pragma mark - get Item

- (id)itemAtIndexPath:(NSIndexPath*)indexPath
{
    if (!self.storageArray.count)
    {
        return nil;
    }
    
    if (indexPath.row > ((NSInteger)self.storageArray.count - 1))
    {
        return nil;
    }
    return [self.storageArray objectAtIndex:indexPath.row];
}

- (void)addItem:(id)item
{
    [self addItems:@[item]];
}

- (void)addItems:(NSArray*)items
{
    if (!BSIsEmpty(items))
    {
        [self.storageArray addObjectsFromArray:items];
        NSMutableArray* indexArray = [NSMutableArray array];
        
        for (id item in items)
        {
            [indexArray addObject:[self _indexPathForItem:item]];
        }
        
        [self.delegate addItemsToIndexPaths:indexArray];
        return;
    }
    
   NSLog(@"Nil-objects not added to tableView");
}

- (void)addItem:(id)item atIndexPath:(NSIndexPath *)indexPath
{
    if (BSIsEmpty(item) || indexPath.section > 0)
    {
        NSLog(@"Nil-object not added to tableView (section = %ld)",(long)indexPath.section);
        return;
    }
    
    if (indexPath.row > self.storageArray.count)
    {
        [self addItem:item];
    }
    else
    {
        [self.storageArray insertObject:item atIndex:indexPath.row];
    }

    [self.delegate addItemsToIndexPaths:@[indexPath]];
}


#pragma mark - Reloading Items

- (void)reloadItems:(NSArray*)items
{
    NSMutableArray* indexPathArray = [NSMutableArray array];
    for (id item in items)
    {
        if (![self.storageArray containsObject:item])
        {
            NSLog(@"TableView not contained %@ item", item);
            continue;
        }
        [indexPathArray addObject:[self _indexPathForItem:item]];
    }
    [self.delegate reloadItemsForIndexPaths:indexPathArray];
}

- (void)reloadItem:(id)item
{
    if (BSIsEmpty(item))
    {
        NSLog(@"Nil-object not added to tableView");
        return;
    }
    [self reloadItems:@[item]];
}


#pragma mark - Removing Items

- (void)removeItem:(id)item
{
    [self removeItems:@[item]];
}

- (void)removeItems:(NSArray*)items
{
    if (!BSIsEmpty(items))
    {
        NSMutableArray* indexArray = [NSMutableArray array];
        for (id item in items)
        {
            if ([self.storageArray containsObject:item])
            {
                [indexArray addObject:[self _indexPathForItem:item]];
                [self.storageArray removeObject:item];
                continue;
            }
            NSLog(@"TableView not contained %@ item", item);
        }

        [self.delegate removeItemsForIndexPaths:indexArray];
        return;
    }
    NSLog(@"Nil-objects not added to tableView");
}

- (void)removeAllItems
{
    [self.storageArray removeAllObjects];
    [self.delegate reloadData];
}

- (void)removeAndAddNewItems:(NSArray*)items
{
    [self.storageArray removeAllObjects];
    [self.storageArray addObjectsFromArray:items];
    [self.delegate reloadData];
}

#pragma mark - Private

- (NSIndexPath*)_indexPathForItem:(id)item
{
    NSInteger row = [self.storageArray indexOfObject:item];
    return [NSIndexPath indexPathForRow:row inSection:0];
}


#pragma mark - Lazy Load

- (NSMutableArray*)storageArray
{
    if (!_storageArray)
    {
        _storageArray = [NSMutableArray array];
    }
    return _storageArray;
}

- (void)beginUpdate {
    [self.delegate beginUpdate];
}
- (void)endUpdate {
    [self.delegate  endUpdate];
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}
@end
