//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRSearchDiscoverPeopleWireframe : NSObject

- (void)presentSearchDiscoverPeopleControllerFromNavigationController:(UINavigationController*)nc tag:(NSString*)tag;
- (void)dismissSearchDiscoverPeopleController;
- (void)presentUserProfile:(UserEntity*)user;
- (void)presentRecomendedUsersFromNavigationController:(UINavigationController*)nc;

@end
