//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchEventByCategoryViewInterface.h"
#import "FRSearchEventByCategoryModuleInterface.h"
#import "FRBaseVC.h"

@interface FRSearchEventByCategoryVC : FRBaseVC <FRSearchEventByCategoryViewInterface>

@property (nonatomic, strong) id<FRSearchEventByCategoryModuleInterface> eventHandler;
- (UITableView*)tableView;

@end
