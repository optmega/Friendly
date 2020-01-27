//
//  FRHomeScreenInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRHomeScreenInteractor.h"
#import "FRUserManager.h"
#import "FRRequestTransport.h"
#import "FRBadgeCountManager.h"
#import "FRLocationManager.h"
#import "FRFriendsTransport.h"
#import "AFNetworking.h"
#import "FRSettingsTransport.h"

@implementation FRHomeScreenInteractor

- (void)loadData
{
    [self.output dataLoaded];
    
    [[FRLocationManager sharedInstance] startUpdateLocationManager];

    [[FRBadgeCountManager new] getEventRequestCount:^(NSInteger count) {
         [FRUserManager sharedInstance].eventRequestsCount = count;
    }];
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachability:) name:AFNetworkingReachabilityDidChangeNotification object:nil];
    
    NSString* referal = [[NSUserDefaults standardUserDefaults] objectForKey:REFERENCE_INVITE];
//    NSString* eventId = [[NSUserDefaults standardUserDefaults] objectForKey:EVENT_ID_INVITE] ?: @"-1";
    
    if (referal) {
        
        [FRSettingsTransport postInviteReferral:referal success:^{
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:REFERENCE_INVITE];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:EVENT_ID_INVITE];
            
            [FRSettingsTransport getUserWithId:referal success:^(UserEntity *userProfile, NSArray *mutualFriends) {
                
                UserEntity* temp = [[NSManagedObjectContext MR_defaultContext] objectWithID:userProfile.objectID];
                
                [[FRUserManager sharedInstance].currentUser addFriendsObject:temp];
            } failure:^(NSError *error) {
                
            }];
            
        } failure:^(NSError *error) {
            
        }];
    }

}

- (void)reachability:(NSNotification*)object {
    
}

@end
