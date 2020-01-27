//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserProfileDataSource;

@protocol FRUserProfileViewInterface <NSObject>

- (void)updateDataSource:(FRUserProfileDataSource*)dataSource;
- (void)updateWallImage:(NSString *)imageUrl;
- (void)updateWithPrivateAccount:(BOOL)isPrivateAccount;
@end
