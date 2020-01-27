//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileInteractor.h"
#import "FRSettingsTransport.h"
#import "FRUserManager.h"
#import "FRFriendsTransport.h"
#import "FRFriendsListModel.h"

@implementation FRMyProfileInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        @weakify(self);
        [[RACObserve([FRUserManager sharedInstance], userModel) deliverOnMainThread] subscribeNext:^(id x) {
            @strongify(self);
            [self updateData];

        }];
    }
    return self;
}

- (void)loadData
{
    BSDispatchBlockToMainQueue(^{
        [self.output dataLoadedWithModel:[FRUserManager sharedInstance].currentUser andUsers:[FRUserManager sharedInstance].currentUser.friends.allObjects];
    });
    
       [FRSettingsTransport profileWithSuccess:^(UserEntity *userProfile, NSArray* mutualFriends) {
    
        
            [FRFriendsTransport getMyFriendsListWithSuccess:^(FRFriendsListModel *friendsList) {
                BSDispatchBlockToMainQueue(^{
                    [FRUserManager sharedInstance].friends = friendsList.friends;
                    [self.output dataLoadedWithModel:[FRUserManager sharedInstance].currentUser andUsers:[FRUserManager sharedInstance].currentUser.friends.allObjects];
                });

            } failure:^(NSError *error) {
                //
            }];
            } failure:^(NSError *error) {
            
    }];
}

- (void)changeStatus:(NSInteger)status {
    [FRSettingsTransport changeUserStatus:status success:^{
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)updateData
{
    [self.output dataLoadedWithModel:[FRUserManager sharedInstance].currentUser andUsers:[FRUserManager sharedInstance].currentUser.friends.allObjects];
}

@end
