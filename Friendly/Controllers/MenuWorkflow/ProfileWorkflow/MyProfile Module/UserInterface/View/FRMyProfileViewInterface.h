//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRMyProfileDataSource;

@protocol FRMyProfileViewInterface <NSObject>

- (void)updateDataSource:(FRMyProfileDataSource*)dataSource;
- (void)updateWallImage:(NSString*)imageUrl;


@end
