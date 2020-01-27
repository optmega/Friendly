//
//  BSTableController.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSTableViewFactory.h"
#import "BSMemoryStorage.h"


@protocol BSTableControllerDelegate <NSObject>

- (void)changePositionY:(CGFloat)y;

@end

@interface BSTableController : NSObject
<
    UITableViewDataSource,
    UITableViewDelegate,
    UISearchBarDelegate
>

@property (nonatomic, weak) id<BSTableControllerDelegate>scrollDelegate;

@property (nonatomic, retain) BSTableViewFactory* cellFactory;
@property (nonatomic, weak) UITableView* tableView;
@property (nonatomic, strong) id<BSMemoryStorageInterface> storage;

@property (nonatomic, assign) UITableViewRowAnimation addAnimation;
@property (nonatomic, assign) UITableViewRowAnimation removeAnimation;


- (BSMemoryStorage*)memoryStorage;

- (instancetype)initWithTableView:(UITableView*)tableView;
- (void)registerCellClass:(Class)cellClass forModelClass:(Class)modelClass;
- (void)registerHeaderClass:(Class)headerClass forModelClass:(Class)modelClass;
- (void)registerFooterClass:(Class)footerClass forModelClass:(Class)modelClass;


@end
