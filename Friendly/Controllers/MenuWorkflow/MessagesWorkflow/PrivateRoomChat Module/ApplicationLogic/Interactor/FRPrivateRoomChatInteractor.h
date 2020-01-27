//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatInteractorIO.h"

@interface FRPrivateRoomChatInteractor : NSObject <FRPrivateRoomChatInteractorInput>

@property (nonatomic, weak) id<FRPrivateRoomChatInteractorOutput> output;
@property (nonatomic, strong) UserEntity* user;

@end

