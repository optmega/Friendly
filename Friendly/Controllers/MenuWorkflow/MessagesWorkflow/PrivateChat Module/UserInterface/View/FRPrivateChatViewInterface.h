//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRPrivateChatDataSource, JSQMessage, FRGroupUsersHeaderViewModel, FRGroupRoom, FRPrivateChatUserHeaderViewModel;

@protocol FRPrivateChatViewInterface <NSObject>

- (void)updateDataSource:(FRPrivateChatDataSource*)dataSource event:(FREvent*)event;
- (void)updateMessages:(NSArray*)messages;
- (void)recivedMessage:(JSQMessage*)message;
- (void)updateUserPhotos:(NSDictionary*)dict;
- (void)updateTitle:(NSString*)title image:(NSString*)imageUrl;
- (void)updateGroupHeader:(FRGroupUsersHeaderViewModel*)model;
- (void)updateWithGroup:(FRGroupRoom*)groupRoom;
- (void)updatePrivateHeader:(FRPrivateChatUserHeaderViewModel*)model;

- (void)updateLastMessage:(JSQMessage*)message;
- (void)oldMessageLoaded;
- (void)setupWithRoomId:(NSString*)roomId;
@end
