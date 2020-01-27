//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeInteractor.h"
#import "FREventTransport.h"
#import "FRLocationManager.h"
#import "UserEntity.h"
#import "FRSettingsTransport.h"
#import "FRFriendsTransport.h"

@interface FRHomeInteractor ()

@property (nonatomic, assign) NSInteger nearbyPage;

@end

@implementation FRHomeInteractor

- (void)loadData
{
    [self.output dataLoaded];

    [FRFriendsTransport getMyFriendsListWithSuccess:^(FRFriendsListModel *friendsList) {
        
        [self updateNearbyForPage:1];
        self.nearbyPage = 1;
    } failure:^(NSError *error) {
        
    }];
}

- (void)updateOldEvent
{
    self.nearbyPage +=1;
    
    [self updateNearbyForPage:self.nearbyPage];
}

- (void)willApear {
    self.nearbyPage = 1;
}

- (void)updateNewEvent
{
    [self updateNearbyForPage:1];
}

- (void)updateNearbyForPage:(NSInteger)page
{
//    [self updateFeatured];
    
    BSDispatchBlockToBackgroundQueue(^{
        
        CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
        
        @weakify(self);
        
        
        [FREventTransport getNearbyListLat:[NSString stringWithFormat:@"%f", location.latitude]
                                       lon:[NSString stringWithFormat:@"%f", location.longitude]
                                      page:page
                                   success:^(NSArray<FREvent*>* events) {
                                       
                                       
                                       @strongify(self);
                                       //                                   [self.output eventUpdated];
                                       
                                       if (page == 1) {
                                           
                                           [self updateFeatured];
                                       }
                                       
                                   } failure:^(NSError *error) {
                                       @strongify(self);
                                       NSLog(@"%@", error.localizedDescription);
                                       
                                       if (page == 1) {
                                           [self updateFeatured];
                                       }
                                   }];
    });
    
}


- (void)updateFeatured
{
    @weakify(self);
    [FREventTransport getFeaturedListWithPage:1 success:^(FREventModels *models) {
        @strongify(self);
        [self.output featuredLoaded:models.eventEntitys];
    } failure:^(NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        @strongify(self);
        [self.output featuredLoaded:nil];
    }];
}

- (void)selectedUserId:(NSString*)userId
{
    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
    
    if (!user)
    {
        [self.output showHudWithType:FRHomeHudTypeShowHud title:nil message:nil];
       
        @weakify(self);
        [FRSettingsTransport profileFofUserId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
            @strongify(self);
            
            [self.output showHudWithType:FRHomeHudTypeHideHud title:nil message:nil];
            UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
            [self.output userProfileLoaded:user];
            
        } failure:^(NSError *error) {
            @strongify(self);
            [self.output showHudWithType:FRHomeHudTypeError title:@"Error" message:error.localizedDescription];
        }];
        
        return;
    }
    
    [self.output userProfileLoaded:user];
}



@end
