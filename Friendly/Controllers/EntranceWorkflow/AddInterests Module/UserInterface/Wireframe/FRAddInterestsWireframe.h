//
//  FRAddInterestsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRRecomendedUserModels;

@interface FRAddInterestsWireframe : NSObject

- (void)presentAddInterestsControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissAddInterestsController;
- (void)presentRecommendedUsersControllerWithInterests:(NSArray*)interests;
- (void)presentRecommendedUsersControllerUsers:(FRRecomendedUserModels*)users interests:(NSArray*)interests;
- (void)presentSettingsWithInterests:(NSArray*) interests;
@end
