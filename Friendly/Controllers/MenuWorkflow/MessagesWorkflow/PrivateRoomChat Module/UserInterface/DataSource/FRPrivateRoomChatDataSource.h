//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage;


@protocol FRPrivateRoomChatDataSourceDelegate <NSObject>

@end

@interface FRPrivateRoomChatDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRPrivateRoomChatDataSourceDelegate> delegate;

- (void)setupStorage;

@end
