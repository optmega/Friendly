//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREvent;

@protocol FRFriendsEventsModuleInterface <NSObject>

- (void)backSelected;
- (void)updateNewEvent;
- (void)updateOldEventWithCount:(NSInteger)countEvents;
- (void)selectedFriendsInvite;

- (void)userPhotoSelected:(NSString*)userId;
- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)selectedShareEvent:(FREvent*)eventId;
- (void)selectedEvent:(FREvent*)event fromFrame:(CGRect)frame;
- (void)selectedFriend:(UserEntity*)user;

- (void)updateAvailableFriends:(NSInteger)count;
- (void)showAddUsers;

@end
