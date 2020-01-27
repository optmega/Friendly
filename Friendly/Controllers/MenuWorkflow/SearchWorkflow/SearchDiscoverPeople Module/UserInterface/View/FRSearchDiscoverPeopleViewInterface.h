//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRSearchDiscoverPeopleDataSource;

@protocol FRSearchDiscoverPeopleViewInterface <NSObject>

- (void)updateDataSource:(FRSearchDiscoverPeopleDataSource*)dataSource;
- (void)updateSaerchBarText:(NSString*)text;

@end
