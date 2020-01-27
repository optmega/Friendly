//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileInteractor.h"
#import "FRSettingsTransport.h"
#import "FRFriendsTransport.h"
#import "FRUserModel.h"

@interface FRUserProfileInteractor()


@end

@implementation FRUserProfileInteractor

- (void)loadDataWithUser:(UserEntity*)user
{
    if (user.objectID)
    {
        self.user = [[NSManagedObjectContext MR_defaultContext] objectWithID:user.objectID];
    }
    
    
    [FRSettingsTransport profileFofUserId:[self.user user_id] success:^(UserEntity* userProfile, NSArray* mutualFriends){

//        if ([userProfile user_id]) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
            UserEntity* userUp = [context objectWithID:user.objectID];
            [self.output dataLoadedWithUserModel:userUp mutual:userUp.mutualFriend.allObjects];
//        }
        
        
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRUserProfileHudTypeError title:FRLocalizedString(@"Error", nil) message:error.localizedDescription];
    }];
    
    [self.output dataLoadedWithUserModel:self.user mutual:self.user.mutualFriend.allObjects];
    
}

- (void)removeUserWithId:(NSString*)userId
{
    [FRFriendsTransport removeUserWithId:userId success:^{
        
        [self.output backSelected];
        
    } failure:^(NSError *error) {
        //
    }];
}

- (void)blockUserWithId:(NSString*)userId
{
    [FRFriendsTransport blockUserWithId:userId success:^{
        [self.output backSelected];
        //
    } failure:^(NSError *error) {
        //
    }];
}

- (void)reportUserWithId:(NSString*)userId
{
    [FRFriendsTransport reportUserWithId:userId success:^{
        //
    } failure:^(NSError *error) {
        //
    }];
}

- (void)updateData
{
    [self loadDataWithUser:self.user];
}

@end
