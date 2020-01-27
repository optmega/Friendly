//
//  BSTableController.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@interface BSTableController ()
<
    BSTableViewFactoryDelegate,
    BSMemoryStorageDelegate
>

@end


@implementation BSTableController

@synthesize storage = _storage;

- (instancetype)initWithTableView:(UITableView*)tableView
{
    self = [super init];
    if (self)
    {
        self.tableView = tableView;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        
        [self _setupTableViewControllerDefaults];
    }
    return self;
}

- (void)dealloc
{
    self.tableView.delegate = nil;
    self.tableView.dataSource = nil;
    self.cellFactory.delegate = nil;
    if ([self.storage respondsToSelector:@selector(setDelegate:)])
    {
        [self.storage setDelegate:nil];
    }
}


- (void)_setupTableViewControllerDefaults
{
    _cellFactory = [BSTableViewFactory new];
    _cellFactory.delegate = self;
}

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.addAnimation = UITableViewRowAnimationTop;
        NSString * reason = [NSString stringWithFormat:@"You shouldn't init class %@ with method %@\n Please use initWithTableView method.",
                             NSStringFromSelector(_cmd), NSStringFromClass([self class])];
        NSException * exc =
        [NSException exceptionWithName:[NSString stringWithFormat:@"%@ Exception", NSStringFromClass([self class])]
                                reason:reason
                              userInfo:nil];
        [exc raise];
    }
    return self;
}

- (void)scrollToTop
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
}


#pragma mark - getter/setter

- (BSMemoryStorage *)memoryStorage
{
    if ([self.storage isKindOfClass:[BSMemoryStorage class]])
    {
        return (BSMemoryStorage *)self.storage;
    }
    return nil;
}

- (id<BSMemoryStorageInterface>)storage
{
    if (!_storage)
    {
        _storage = [BSMemoryStorage storage];
        [self _attachStorage:_storage];
    }
    return _storage;
}

- (void)setStorage:(id <BSMemoryStorageInterface>)storage
{
    _storage = storage;
    [self _attachStorage:_storage];
}



#pragma mark - UITableView Class Registrations

- (void)registerCellClass:(Class)cellClass forModelClass:(Class)modelClass
{
    [self.cellFactory registerCellClass:cellClass forModelClass:modelClass];
}

- (void)registerHeaderClass:(Class)headerClass forModelClass:(Class)modelClass
{
    [self.cellFactory registerHeaderFooterClass:headerClass forModelClass:modelClass type:BSSupplementaryViewHeader];
}

- (void)registerFooterClass:(Class)footerClass forModelClass:(Class)modelClass
{
    [self.cellFactory registerHeaderFooterClass:footerClass forModelClass:modelClass type:BSSupplementaryViewFooter];
}


#pragma mark - Private

- (void)_attachStorage:(id<BSMemoryStorageInterface>)storage
{
    storage.delegate = (id<BSMemoryStorageDelegate>)self;
   if ( self.memoryStorage.storageArray.count)
   {
       [self.tableView reloadData];
   }
}


#pragma mark - UITableView Protocols Implementation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[self memoryStorage] storageArray] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray* storageArray = [[self memoryStorage] storageArray];
    id model = [storageArray objectAtIndex:indexPath.row];
    
    return [self.cellFactory cellForModel:model atIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;

}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.scrollDelegate changePositionY:scrollView.contentOffset.y];
}

#pragma mark - BSMemoryStorageDelegate

- (void)reloadData
{
    [self.tableView reloadData];
}

- (void)addItemsToIndexPaths:(NSArray*)indexPaths
{
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:self.addAnimation];
}

- (void)reloadItemsForIndexPaths:(NSArray*)indexPaths
{
    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
}
- (void)removeItemsForIndexPaths:(NSArray*)indexPaths
{
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:self.removeAnimation];
}

- (void)beginUpdate {
    [self.tableView beginUpdates];
}
- (void)endUpdate {
    [self.tableView endUpdates];
}


@end
