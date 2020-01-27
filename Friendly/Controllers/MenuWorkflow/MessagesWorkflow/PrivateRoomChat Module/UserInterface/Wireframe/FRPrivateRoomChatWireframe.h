//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@interface FRPrivateRoomChatWireframe : NSObject

- (void)presentPrivateRoomChatControllerFromNavigationController:(UIViewController*)nc userEntity:(UserEntity*)user;
- (void)dismissPrivateRoomChatController;
- (void)presentInviteToEventController:(NSString*)userId;

- (void)presentUserProfile:(UserEntity*)user;

@end
