//
//  FRCreateEventInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 8.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@protocol FRCreateEventModuleInterface <NSObject>

- (void)backSelected;
- (void)createEventSelected;
- (void)deleteEvent;
- (void)partnerHostingSelectedWith:(NSString*)eventId;
- (void)inviteFriendsSelected;
- (void)inviteFriendsSelectedWith:(NSString *)eventId;
- (void)categorySelected;
- (void)agesSelected;
- (void)genderSelected;
- (void)openSlotsSelected;
- (void)timeSelected;
- (void)dateSelected;
- (void)locationSelected;
- (void)updateEventSelected;

@end
