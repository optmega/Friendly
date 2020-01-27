//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRPrivateRoomChatDataSource, FRPrivateChatUserHeaderViewModel;

@protocol FRPrivateRoomChatViewInterface <NSObject>

- (void)updateDataSource:(FRPrivateRoomChatDataSource*)dataSource;
- (void)updatePrivateHeader:(FRPrivateChatUserHeaderViewModel*)model;
- (void)setupWithRoomId:(NSString*)roomId;
- (void)oldMessageLoaded;
- (void)userId:(NSString*)userId;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSString* titleImage;

@end
