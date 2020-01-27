//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsInteractor.h"
#import "FREventTransport.h"
#import "FRSettingsTransport.h"
#import "FRFriendsTransport.h"

@interface FRFriendsEventsInteractor ()

@property (nonatomic, assign) NSInteger friendsPage;

@end

@implementation FRFriendsEventsInteractor

- (void)loadData
{
    [self.output dataLoaded];
    
    [self updateFriendsEventsForPage:1];
    self.friendsPage = 1;
    
    [self updateFriendPage:1];
//    [FRFriendsTransport getMyFriendsListPage:1 success:^(FRFriendsListModel *friendsList) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
//    [FRFriendsTransport getAvailableForMeetFriendsPage:1 success:^(FRFriendsListModel *friendsList) {
//        
//    } failure:^(NSError *error) {
//        
//    }];
}

- (void)updateAvailableFriends:(NSInteger)count {
    [self updateFriendPage:count / 10 + 1];
}

- (void)updateFriendPage:(NSInteger)page {
    [FRFriendsTransport getMyFriendsListPage:page success:^(FRFriendsListModel *friendsList) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)updateOldEvent:(NSInteger)countEvents
{
    self.friendsPage += 1;
    
    if ((countEvents / 10 + 1) < self.friendsPage) {
        self.friendsPage = countEvents / 10 + 1;
    };
    
    [self updateFriendsEventsForPage:self.friendsPage];
}

- (void)updateNewEvent
{
    [self updateFriendsEventsForPage:1];
}

- (void)updateFriendsEventsForPage:(NSInteger)page
{
    @weakify(self);
    
    [FREventTransport getFriendWithFilter:false page:page list:^(NSArray<FREvent*>* events) {
        
        @strongify(self);
        [self.output eventUpdated];
        
    } failure:^(NSError *error) {
        
        @strongify(self);
        NSLog(@"%@", error.localizedDescription);
        [self.output eventUpdated];

    }];
}

- (void)selectedUserId:(NSString*)userId
{
    UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
    
    if (!user)
    {
        [self.output showHudWithType:FRFriendsEventsHudTypeShowHud title:nil message:nil];
        
        @weakify(self);
        [FRSettingsTransport profileFofUserId:userId success:^(UserEntity *userProfile, NSArray *mutualFriends) {
            @strongify(self);
            
            [self.output showHudWithType:FRFriendsEventsHudTypeHideHud title:nil message:nil];
            UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userId]];
            [self.output userProfileLoaded:user];
            
        } failure:^(NSError *error) {
            @strongify(self);
            [self.output showHudWithType:FRFriendsEventsHudTypeError title:@"Error" message:error.localizedDescription];
        }];
        
        return;
    }
    
    [self.output userProfileLoaded:user];
}


@end
