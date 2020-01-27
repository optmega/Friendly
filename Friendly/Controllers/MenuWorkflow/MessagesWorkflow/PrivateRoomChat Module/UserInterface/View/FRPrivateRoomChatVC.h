//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatViewInterface.h"
#import "FRPrivateRoomChatModuleInterface.h"
#import "FRBaseVC.h"


#import "FRPrivateChatViewInterface.h"
#import "FRPrivateChatModuleInterface.h"
#import "FRBaseVC.h"

#import "JSQMessages.h"
#import "FRChatMessageModelData.h"


@interface FRPrivateRoomChatVC : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, FRPrivateRoomChatViewInterface>

@property (nonatomic, strong) id<FRPrivateRoomChatModuleInterface> eventHandler;

- (void)closePressed:(UIBarButtonItem *)sender;
@property (nonatomic, strong) NSString* titleString;
@property (nonatomic, strong) NSString* titleImage;
@property (nonatomic, strong) UserEntity* user;


@end
