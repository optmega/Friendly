//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMessagerInteractor.h"
#import "FRPrivateRoom.h"
#import "FRGroupRoom.h"
#import "FRChatTransport.h"
#import "FREventTransport.h"
#import "FRFriendsTransport.h"

@implementation FRMessagerInteractor

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(recivedMessage:) name:kReciveNewMessages object:nil];
    }
    return self;
}

- (void)searchRoomForTitle:(NSString*)searchText {
}

- (void)recivedMessage:(NSNotification*)sender
{
    [self loadChats];
}

- (void)updateAvailableFriends:(NSInteger)count {
    [self updateFriendPage:count / 10 + 1];
}

- (void)updateFriendPage:(NSInteger)page {
    [FRFriendsTransport getMyFriendsListPage:page success:^(FRFriendsListModel *friendsList) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)loadData
{
    
    [FRChatTransport getAllRooms:^(FRChatRooms *rooms) {
        
    } failure:^(NSError *error) {
        
    }];
    
    [[FRWebSoketManager shared] connect];
    [self.output dataLoaded];
    [self loadChats];
}

- (void)loadChats
{
    NSArray* groupRooms = [FRGroupRoom MR_findAllSortedBy:@"lastMessageDate" ascending:NO];

    [groupRooms enumerateObjectsUsingBlock:^(FRGroupRoom*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        FREvent* event = [FREventTransport getEventForId:obj.eventId success:nil failure:nil];
        if (!event) {
            [FRDataBaseManager updateGroupRoomWithEventID:obj.eventId];
        } else {
            [FRGroupRoom initOrUpdateGroupRoomWithModel:event inContext:event.managedObjectContext];
        }
    }];
}

- (void)updateChatRoomsWithCount:(NSInteger)countRooms {
    
    NSUInteger count = [FRBaseRoom MR_countOfEntities];
    
    static NSInteger page = 2;
    if (page > (count / 10) + 1) {
        page = (count / 10) + 1;
    }
    
    [FRChatTransport getRoomsForPage:page success:^(FRChatRooms *rooms) {
        
        [self.output updateChats];

    } failure:^(NSError *error) {
        [self.output updateChats];

    }];
    
    page++;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
