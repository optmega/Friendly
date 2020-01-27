//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRSearchEventByCategoryDataSource;

@protocol FRSearchEventByCategoryViewInterface <NSObject>

- (void)updateSaerchBarText:(NSString*)text;
- (void)updateDataSource:(FRSearchEventByCategoryDataSource*)dataSource;
- (UITableView*)tableView;
@end
