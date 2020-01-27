//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatInteractor.h"
#import "FRChatTransport.h"
#import "FRRoomModel.h"
#import "FRPrivateMessage.h"
#import "FRLocationManager.h"
#import "FRFriendsTransport.h"

@interface FRPrivateRoomChatInteractor ()

@property (nonatomic, strong) NSString* roomId;
@end

@implementation FRPrivateRoomChatInteractor

- (void)loadDataWithUser:(UserEntity*)userT
{
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:userT.objectID];
    self.user = user;
    @weakify(self);
    
    [self.output showHudWithType:FRPrivateRoomChatHudTypeShowHud title:nil message:nil];
    
    FRPrivateRoom* room = [FRPrivateRoom MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"opponent.user_id == %@", user.user_id] inContext:[NSManagedObjectContext MR_defaultContext]];
    if (room) {
        
        [FRUserManager sharedInstance].openRoomId = room.roomId;
        self.roomId = room.roomId;
        [self.output dataLoadedWithRoomId:room.roomId];
        [self.output showHudWithType:FRPrivateRoomChatHudTypeHideHud title:nil message:nil];
    }
    [self loadOldMessageWithCount:1];
    [FRChatTransport createRoomForUserId:[user user_id] success:^(FRRoomModel* room, NSArray* messages) {
        
        @strongify(self);
        [FRDataBaseManager updatePrivateRoomMessages:messages];
        [FRUserManager sharedInstance].openRoomId = room.id;
        self.roomId = room.id;
        [self.output dataLoadedWithRoomId:room.id];
        [self.output showHudWithType:FRPrivateRoomChatHudTypeHideHud title:nil message:nil];
        
    } failure:^(NSError *error) {
        @strongify(self);
        [self.output showHudWithType:FRPrivateRoomChatHudTypeError title:@"Error" message:error.localizedDescription];
    }];
}

- (void)reciveMessage:(NSNotification*)sender
{
    BSDispatchBlockToBackgroundQueue(^{
        
        if ([sender.object isKindOfClass:[FRPrivateMessage class]])
        {
            FRPrivateMessage* privateMessage = sender.object;
            if (privateMessage.room.roomId.integerValue == self.roomId.integerValue)
            {
                BSDispatchBlockToMainQueue(^{
                    
                    privateMessage.room.isNewMessage = false;
                });
                
                if (privateMessage.creatorId.integerValue != [FRUserManager sharedInstance].userId.integerValue)
                {
                    [FRDataBaseManager updateStatusToReadMessages:@[privateMessage]];
                }
            }
        }
      
    });
    
}


- (void)sendMessage:(NSString*)textMessage
{
    [[FRDataBaseManager  shared] sendMessage:textMessage toUser:self.user roomId:self.roomId];
}

- (void)shareLocation
{
    if ([[FRLocationManager sharedInstance] verifiLocationManager])
    {
        CLLocationCoordinate2D location = [FRLocationManager sharedInstance].location;
        if (location.latitude || location.latitude || true)
        {
            NSString* locationMessage = [NSString stringWithFormat:@"{\"MyLocation\": { \"lat\":%f, \"lon\":%f }}", location.latitude, location.longitude];
            [self sendMessage:locationMessage];
        }
    };
}

- (void)loadOldMessageWithCount:(NSInteger) messagesCount
{
    static NSInteger mesCount = 2;
    mesCount = messagesCount / 25 + 1;
    
    [FRChatTransport getMessageForRoom:self.roomId forPage:mesCount success:^(id chats) {
        [self.output messageLoaded];
        
    } failure:^(NSError * error) {
        [self.output messageLoaded];
    }];
    
    mesCount++;
}

- (void)removeUser {

}

- (void)blockUser {
    [self.output showHudWithType:FRPrivateRoomChatHudTypeShowHud title:nil message:nil];
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.user.objectID];

    [FRFriendsTransport blockUserWithId:user.user_id success:^{
        [self.output showHudWithType:FRPrivateRoomChatHudTypeHideHud title:nil message:nil];
        [self.output backSelected];
    } failure:^(NSError *error) {
        [self.output showHudWithType:FRPrivateRoomChatHudTypeError title:@"Error" message:error.localizedDescription];

    }];

}

- (void)reportUser {
    [self.output showHudWithType:FRPrivateRoomChatHudTypeShowHud title:nil message:nil];
    
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:self.user.objectID];
        [FRFriendsTransport reportUserWithId:user.user_id success:^{
        [self.output backSelected];

    } failure:^(NSError *error) {
        [self.output showHudWithType:FRPrivateRoomChatHudTypeError title:@"Error" message:error.localizedDescription];

    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [FRUserManager sharedInstance].openRoomId = nil;
}

@end
