//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatInteractorIO.h"
#import "FRPrivateRoomChatWireframe.h"
#import "FRPrivateRoomChatViewInterface.h"
#import "FRPrivateRoomChatModuleDelegate.h"
#import "FRPrivateRoomChatModuleInterface.h"

@interface FRPrivateRoomChatPresenter : NSObject <FRPrivateRoomChatInteractorOutput, FRPrivateRoomChatModuleInterface>

@property (nonatomic, strong) id<FRPrivateRoomChatInteractorInput> interactor;
@property (nonatomic, strong) FRPrivateRoomChatWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRPrivateRoomChatViewInterface>* userInterface;
@property (nonatomic, weak) id<FRPrivateRoomChatModuleDelegate> privateRoomChatModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRPrivateRoomChatViewInterface>*)userInterface userEntity:(UserEntity*)user;

@end
