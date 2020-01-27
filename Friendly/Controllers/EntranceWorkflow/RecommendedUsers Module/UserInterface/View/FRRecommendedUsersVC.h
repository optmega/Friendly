//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersViewInterface.h"
#import "FRRecommendedUsersModuleInterface.h"
#import "FRBaseVC.h"

@interface FRRecommendedUsersVC : FRBaseVC <FRRecommendedUsersViewInterface>

@property (nonatomic, strong) id<FRRecommendedUsersModuleInterface> eventHandler;
@property (nonatomic, assign) BOOL isAddFriendsMode;
@end
