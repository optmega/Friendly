//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

typedef NS_ENUM(NSInteger, FRPrivateRoomChatHudType) {
    FRPrivateRoomChatHudTypeError,
    FRPrivateRoomChatHudTypeShowHud,
    FRPrivateRoomChatHudTypeHideHud,
};

@protocol FRPrivateRoomChatInteractorInput <NSObject>


- (void)shareLocation;
- (void)loadDataWithUser:(UserEntity*)user;
- (void)sendMessage:(NSString*)textMessage;
- (void)loadOldMessageWithCount:(NSInteger) messagesCount;
@property (nonatomic, readonly) NSString* roomId;
@property (nonatomic, strong) UserEntity* user;

- (void)removeUser;
- (void)blockUser;
- (void)reportUser;
- (void)inviteToUser;

@end


@protocol FRPrivateRoomChatInteractorOutput <NSObject>

- (void)messageLoaded;
- (void)dataLoadedWithRoomId:(NSString*)roomId;
- (void)showHudWithType:(FRPrivateRoomChatHudType)type title:(NSString*)title message:(NSString*)message;
- (void)backSelected;
@end