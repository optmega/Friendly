//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRMessagerHudType) {
    FRMessagerHudTypeError,
    FRMessagerHudTypeShowHud,
    FRMessagerHudTypeHideHud,
};

@protocol FRMessagerInteractorInput <NSObject>

- (void)loadData;
- (void)searchRoomForTitle:(NSString*)searchText;
- (void)loadChats;
- (void)updateChatRoomsWithCount:(NSInteger)countRooms;
- (void)updateAvailableFriends:(NSInteger)count;

@end


@protocol FRMessagerInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)showHudWithType:(FRMessagerHudType)type title:(NSString*)title message:(NSString*)message;
- (void)updateChats;

@end