//
//  FRRecommendedUsersInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRRecommendedUsersWireframe.h"
#import "FRRecommendedUsersInteractor.h"
#import "FRRecommendedUsersVC.h"
#import "FRRecommendedUsersPresenter.h"
#import "FRHomeScreenWireframe.h"
#import "FRProfilePolishWireframe.h"
#import "FRSettingsTransport.h"
#import "FRUserProfileWireframe.h"

@interface FRRecommendedUsersWireframe ()

@property (nonatomic, weak) FRRecommendedUsersPresenter* presenter;
@property (nonatomic, weak) FRRecommendedUsersVC* recommendedUsersController;
@property (nonatomic, weak) UINavigationController* presentedController;
@property (nonatomic, copy) NSArray* interests;
@property (nonatomic, assign) BOOL isAddFriendsMode;
@end

@implementation FRRecommendedUsersWireframe

- (void)presentAddFriendsControllerFrom:(UINavigationController*)nc {
    
    [self presentRecommendedUsersControllerFromNavigationController:nc  interests:nil addFriendsMode:true users:nil];

}

- (void)presentRecommendedUsersControllerFromNavigationController:(UINavigationController*)nc interests:(NSArray*)interests users:(id)users {
    
    [self presentRecommendedUsersControllerFromNavigationController:nc  interests:interests addFriendsMode:false users:users];
}

- (void)presentRecommendedUsersControllerFromNavigationController:(UINavigationController*)nc interests:(NSArray*)interests addFriendsMode:(BOOL)isFriendsMode users:(FRRecomendedUserModels*)users
{
    self.isAddFriendsMode = isFriendsMode;
    self.interests = interests;
    
    FRRecommendedUsersVC* recommendedUsersController = [FRRecommendedUsersVC new];
    FRRecommendedUsersInteractor* interactor = [FRRecommendedUsersInteractor new];
    FRRecommendedUsersPresenter* presenter = [FRRecommendedUsersPresenter new];
    
    recommendedUsersController.isAddFriendsMode = isFriendsMode;
    interactor.output = presenter;
    
    recommendedUsersController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:recommendedUsersController users:users];
    
    
    BSDispatchBlockToMainQueue(^{
        
        if ([nc isKindOfClass:[UINavigationController class]]) {
            
            if (isFriendsMode) {
                [nc.topViewController presentViewController:recommendedUsersController animated:true completion:nil];
            } else {
                [nc pushViewController:recommendedUsersController animated:NO];
            }
        } else {
            [nc presentViewController:recommendedUsersController animated:true completion:nil];
        }
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.recommendedUsersController = recommendedUsersController;
}

- (void)dismissRecommendedUsersController
{
    if (self.isAddFriendsMode) {
        [self.recommendedUsersController dismissViewControllerAnimated:true completion:nil];
    } else {
        
        [self.presentedController popViewControllerAnimated:NO];
    }
}

- (void)presentHomeScreenController
{
    [[FRHomeScreenWireframe new] presentHomeScreenControllerFromNavigationController:self.presentedController];
}

- (void)presentProfilePolish
{
    [[FRProfilePolishWireframe new]presentProfilePolishControllerFromNavigationController:self.presentedController interests:self.interests];
}

- (void)showUserProfileWithId:(NSString*)userId
{
    FRUserProfileWireframe* wf = [FRUserProfileWireframe new];
    UserEntity* user = [FRSettingsTransport getUserWithId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends)
                        {
                    
                            [wf presentUserProfileFromViewController:self.recommendedUsersController user:userProfile fromLoginFlow:YES];
                        } failure:^(NSError *error) {
                            //
                        }];
    if (user)
    {
//           [wf presentUserProfileControllerFromNavigationController:self.presentedController user:user withAnimation:NO];
        [wf presentUserProfileFromViewController:self.recommendedUsersController user:user fromLoginFlow:YES];
    }

}

@end
