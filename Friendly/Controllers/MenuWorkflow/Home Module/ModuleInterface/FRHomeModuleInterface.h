//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//
@class FREvent;

@protocol FRHomeModuleInterface <NSObject>

- (void)backSelected;
- (void)updateOldEvent;
- (void)updateNewEvent;
- (void)showFilter;
- (void)showFriendsEvents;
- (void)showSearchEvents;

- (void)userPhotoSelected:(NSString*)userId;
- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)selectedShareEvent:(FREvent*)eventId;
- (void)selectedEvent:(FREvent*)event fromFrame:(CGRect)frame;
- (void)showAddFriends;
- (void)willApear;
@end
