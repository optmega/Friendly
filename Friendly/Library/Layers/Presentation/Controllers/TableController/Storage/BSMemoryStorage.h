//
//  BSMemoryStorage.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@protocol BSMemoryStorageDelegate <NSObject>

- (void)reloadData;
- (void)addItemsToIndexPaths:(NSArray*)indexPaths;
- (void)reloadItemsForIndexPaths:(NSArray*)indexPaths;
- (void)removeItemsForIndexPaths:(NSArray*)indexPaths;
- (void)scrollToTop;

- (void)beginUpdate;
- (void)endUpdate;
@end


@protocol BSMemoryStorageInterface <NSObject>

@property (nonatomic, weak) id<BSMemoryStorageDelegate> delegate;

@end


@interface BSMemoryStorage : NSObject <BSMemoryStorageInterface>

@property (nonatomic, strong) NSMutableArray* storageArray;
@property (nonatomic, weak) id<BSMemoryStorageDelegate> delegate;

+ (instancetype)storage;

#pragma mark - get Item

- (id)itemAtIndexPath:(NSIndexPath*)indexPath;


#pragma mark - Add supplimentary

- (void)addFooter:(id)footer forSection:(NSInteger)section;
- (void)addHeader:(id)header forSection:(NSInteger)section;



#pragma mark - Adding Items

// Add item to section 0.
- (void)addItem:(id)item;
- (void)addItems:(NSArray*)items;
- (void)addItem:(id)item atIndexPath:(NSIndexPath *)indexPath;
- (void)scrollToTop;


#pragma mark - Reloading Items

- (void)reloadItem:(id)item;
- (void)reloadItems:(NSArray*)items;
- (void)removeAndAddNewItems:(NSArray*)items;



#pragma mark - Removing Items

- (void)removeItem:(id)item;
- (void)removeItems:(NSArray*)items;
- (void)removeAllItems;

- (void)beginUpdate;
- (void)endUpdate;

@end
