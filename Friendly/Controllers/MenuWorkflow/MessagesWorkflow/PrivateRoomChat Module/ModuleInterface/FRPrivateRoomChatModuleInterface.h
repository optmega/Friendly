//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//
@class JSQMessage, FRBaseMessage;

@protocol FRPrivateRoomChatModuleInterface <NSObject>

- (void)backSelected;
- (void)sendMessage:(NSString*)message;
- (NSString*)roomId;
- (JSQMessage*)createJSQMessage:(FRBaseMessage*)message;
- (void)shareLocation;
- (void)loadOldMessageWithCount:(NSInteger)count;
- (void)showUserProfile:(NSString*)userId;

- (UserEntity*)userEntity;

- (void)removeUser;
- (void)blockUser;
- (void)reportUser;
- (void)inviteToUser;
- (void)viewWillAppear;

@end

