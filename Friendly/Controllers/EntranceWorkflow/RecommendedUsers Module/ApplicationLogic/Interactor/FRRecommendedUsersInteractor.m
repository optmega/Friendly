//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersInteractor.h"
#import "FRSettingsTransport.h"
#import "FRFriendsTransport.h"
#import "FRRecommendedUsersCellViewModel.h"

@implementation FRRecommendedUsersInteractor

- (void)loadData:(FRRecomendedUserModels*)users
{
    if (users) {
        [self.output dataLoadedWithModel:users];
    } else {
        
        [self.output showHudWithType:FRRecommendedUsersHudTypeShowHud title:nil message:nil];
        [FRSettingsTransport recomendedUsersWithSuccess:^(FRRecomendedUserModels *users) {
            [self.output showHudWithType:FRRecommendedUsersHudTypeHideHud title:nil message:nil];
            [self.output dataLoadedWithModel:users];
        } failure:^(NSError *error) {
            [self.output showHudWithType:FRRecommendedUsersHudTypeError title:@"Error" message:error.localizedDescription];
        }];
    }
}

- (void)addUserWithUserModel:(FRRecommendedUsersCellViewModel*)userModel
{
    [FRFriendsTransport inviteFriendsWithId:userModel.userId message:@"" success:^{
        
    } failure:^(NSError *error) {
        userModel.isRequstedMode = NO;
        [self.output reloadData];
    }];
    
}

@end
