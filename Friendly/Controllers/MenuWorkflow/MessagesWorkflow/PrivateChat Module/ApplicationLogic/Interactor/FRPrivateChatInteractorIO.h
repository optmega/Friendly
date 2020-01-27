//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRUserModel, FRPrivateRoom, FRGroupRoom, FRBaseMessage;

typedef NS_ENUM(NSInteger, FRPrivateChatHudType) {
    FRPrivateChatHudTypeError,
    FRPrivateChatHudTypeShowHud,
    FRPrivateChatHudTypeHideHud,
};

@protocol FRPrivateChatInteractorInput <NSObject>

- (void)shareLocation;

- (void)loadChatForEvent:(FREvent*)room;
- (void)sendMessage:(NSString*)textMessage;
- (void)loadOldMessages:(NSInteger)count;
- (void)userEntityForId:(NSString*)userId;
- (void)leaveEvent;
- (void)deleteEvent;
@property (nonatomic, strong, readonly) FREvent* eventForChat;
@property (nonatomic, strong) NSString* roomId;

@end


@protocol FRPrivateChatInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)showHudWithType:(FRPrivateChatHudType)type title:(NSString*)title message:(NSString*)message;
- (void)updateMessageData:(NSArray*)message;
- (void)recivedMessage:(FRBaseMessage*)message;
- (void)userPhotoLoaded:(NSDictionary*)userPhotos;
- (void)locationShared:(NSString*)locationMessage;
- (void)selectUser:(UserEntity*)entity;
- (void)oldMessageLoaded;
- (void)backSelected;

@end