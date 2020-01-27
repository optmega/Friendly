//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRFriendsEventsHudType) {
    FRFriendsEventsHudTypeError,
    FRFriendsEventsHudTypeShowHud,
    FRFriendsEventsHudTypeHideHud,
};

@protocol FRFriendsEventsInteractorInput <NSObject>

- (void)loadData;
- (void)updateOldEvent:(NSInteger)countEvents;
- (void)updateNewEvent;
- (void)selectedUserId:(NSString*)userId;
- (void)updateAvailableFriends:(NSInteger)count;

@end


@protocol FRFriendsEventsInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)showHudWithType:(FRFriendsEventsHudType)type title:(NSString*)title message:(NSString*)message;
- (void)eventUpdated;
- (void)userProfileLoaded:(UserEntity*)user;

@end