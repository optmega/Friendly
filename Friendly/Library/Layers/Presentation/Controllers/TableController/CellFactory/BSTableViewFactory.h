//
//  BSTableViewFactory.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//


typedef NS_ENUM(NSInteger, BSSupplementaryViewType) {
    BSSupplementaryViewHeader,
    BSSupplementaryViewFooter,
};

@protocol BSTableViewFactoryDelegate

- (UITableView *)tableView;

@end

@interface BSTableViewFactory : NSObject

@property (nonatomic, weak) id<BSTableViewFactoryDelegate> delegate;

- (void)registerCellClass:(Class)cellClass
            forModelClass:(Class)modelClass;

- (void)registerHeaderFooterClass:(Class)headerFooterClass
                    forModelClass:(Class)modelClass
                             type:(BSSupplementaryViewType)type;

- (UITableViewCell *)cellForModel:(id)model
                      atIndexPath:(NSIndexPath *)indexPath;

- (UIView*)supplementaryViewForModel:(id)model
                                type:(BSSupplementaryViewType)type;

@end
