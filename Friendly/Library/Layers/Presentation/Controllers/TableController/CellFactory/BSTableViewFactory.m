//
//  BSTableViewFactory.h
//  Friendly
//
//  Created by Sergey Borichev on 26.02.2016.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "BSTableViewFactory.h"
#import "BSBaseTableViewCell.h"
#import "BSRuntimeHelper.h"

@interface BSTableViewFactory ()

@property (nonatomic, strong) NSMutableDictionary* cellMappingsDictionary;
@property (nonatomic, strong) NSMutableDictionary* headerMappingDictionary;
@property (nonatomic, strong) NSMutableDictionary* footerMappingDictionary;

@end

@implementation BSTableViewFactory

- (NSMutableDictionary *)cellMappingsDictionary
{
    if (!_cellMappingsDictionary)
    {
        _cellMappingsDictionary = [NSMutableDictionary new];
    }
    return _cellMappingsDictionary;
}

- (NSMutableDictionary *)headerMappingDictionary
{
    if (!_headerMappingDictionary)
    {
        _headerMappingDictionary = [NSMutableDictionary new];
    }
    return _headerMappingDictionary;
}

- (NSMutableDictionary *)footerMappingDictionary
{
    if (!_footerMappingDictionary)
    {
        _cellMappingsDictionary = [NSMutableDictionary new];
    }
    return _cellMappingsDictionary;
}


- (void)registerCellClass:(Class)cellClass forModelClass:(Class)modelClass
{
    NSParameterAssert([cellClass isSubclassOfClass:[UITableViewCell class]]);
    NSParameterAssert([cellClass conformsToProtocol:@protocol(BSModelTransfer)]);
    NSParameterAssert(modelClass);
    
    NSString * reuseIdentifier = [BSRuntimeHelper classStringForClass:cellClass];
    
    NSParameterAssert(reuseIdentifier);
    reuseIdentifier = reuseIdentifier ? : @"";
    
    [[self.delegate tableView] registerClass:cellClass
                      forCellReuseIdentifier:reuseIdentifier];
    
    [self.cellMappingsDictionary setObject:[BSRuntimeHelper classStringForClass:cellClass]
                                    forKey:[BSRuntimeHelper modelStringForClass:modelClass]];
}

- (void)registerHeaderFooterClass:(Class)headerFooterClass forModelClass:(Class)modelClass type:(BSSupplementaryViewType)type
{
    NSParameterAssert([headerFooterClass isSubclassOfClass:[UITableViewHeaderFooterView class]]);
    NSParameterAssert(modelClass);
    
    NSString * reuseIdentifier = [BSRuntimeHelper classStringForClass:headerFooterClass];
    
    NSParameterAssert(reuseIdentifier);
    reuseIdentifier = reuseIdentifier ? : @"";
    
    [[self.delegate tableView] registerClass:headerFooterClass
          forHeaderFooterViewReuseIdentifier:reuseIdentifier];
    
    
    if (type == BSSupplementaryViewHeader)
    {
        [self.headerMappingDictionary setObject:[BSRuntimeHelper classStringForClass:headerFooterClass]
                                         forKey:[BSRuntimeHelper classStringForClass:modelClass]];
    }
    
    if (type == BSSupplementaryViewFooter)
    {
        [self.footerMappingDictionary setObject:[BSRuntimeHelper classStringForClass:headerFooterClass] forKey:[BSRuntimeHelper classStringForClass:modelClass]];
    }
    
}

- (UIView*)supplementaryViewForModel:(id)model type:(BSSupplementaryViewType)type
{
    Class supplementaryClass = [self _supplementaryClassForModel:model type:type];
    UIView <BSModelTransfer> * view = (id)[self _headerFooterViewForViewClass:supplementaryClass];
    [view updateWithModel:model];
    
    return view;
}


- (UITableViewCell *)cellForModel:(id)model atIndexPath:(NSIndexPath *)indexPath
{
    NSString * reuseIdentifier = [self _cellReuseIdentifierForModel:model];
    NSParameterAssert(reuseIdentifier);
    reuseIdentifier = reuseIdentifier ? : @"";
    
    UITableViewCell <BSModelTransfer> * cell;
    if (reuseIdentifier)
    {
        cell = [[self.delegate tableView] dequeueReusableCellWithIdentifier:reuseIdentifier
                                                               forIndexPath:indexPath];
        [cell updateWithModel:model];
    }
    else
    {
        cell = [BSBaseTableViewCell new];
    }
    return cell;
}

- (NSString *)_cellReuseIdentifierForModel:(id)model
{
    NSString* modelClassName = [BSRuntimeHelper modelStringForClass:[model class]];
    NSString* cellClassString = [self.cellMappingsDictionary objectForKey:modelClassName];
    NSAssert(cellClassString, @"%@ does not have cell mapping for model class: %@",[self class], [model class]);
    
    return cellClassString;
}

- (UIView *)_headerFooterViewForViewClass:(Class)viewClass
{
    NSString * reuseIdentifier = [BSRuntimeHelper classStringForClass:viewClass];
    NSParameterAssert(reuseIdentifier);
    reuseIdentifier = reuseIdentifier ? : @"";
    
    UIView * view = [[self.delegate tableView] dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
    
    return view;
}

- (NSMutableDictionary*)_supplementaryMappingsForType:(BSSupplementaryViewType)type
{
    switch (type)
    {
        case BSSupplementaryViewHeader: return self.headerMappingDictionary; break;
        case BSSupplementaryViewFooter: return self.footerMappingDictionary; break;
        default: return nil; break;
    }
}

- (Class)_supplementaryClassForModel:(id)model type:(BSSupplementaryViewType)type
{
    NSString* modelClassName = [BSRuntimeHelper modelStringForClass:[model class]];
    NSString* supplClassString = [[self _supplementaryMappingsForType:type] objectForKey:modelClassName];
    NSAssert(supplClassString, @"DTCellFactory does not have supplementary mapping for model class: %@",[model class]);
    
    return NSClassFromString(supplClassString);
}

@end
