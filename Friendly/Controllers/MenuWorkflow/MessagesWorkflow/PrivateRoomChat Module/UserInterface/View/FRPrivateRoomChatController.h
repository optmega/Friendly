//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRPrivateRoomChatDataSource;


@interface FRPrivateRoomChatController : BSTableController

- (void)updateDataSource:(FRPrivateRoomChatDataSource*)dataSource;

@end
