//
//  FREditProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREditProfileDataSource;

@protocol FREditProfileViewInterface <NSObject>

- (void)updateDataSource:(FREditProfileDataSource*)dataSource;
- (void)updateWallImage:(UIImage*)image;
- (void)updateWallImageUrl:(NSString*)imageUrl;

@end
