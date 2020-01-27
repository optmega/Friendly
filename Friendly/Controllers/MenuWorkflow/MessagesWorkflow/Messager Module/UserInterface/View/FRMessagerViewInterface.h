//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRMessagerDataSource;

@protocol FRMessagerViewInterface <NSObject>

- (void)updateDataSource:(FRMessagerDataSource*)dataSource;
- (void)updateChats;

@end
