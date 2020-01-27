//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatViewInterface.h"
#import "FRPrivateChatModuleInterface.h"
#import "FRBaseVC.h"

#import "JSQMessages.h"
#import "FRChatMessageModelData.h"

@interface FRPrivateChatVC : JSQMessagesViewController <UIActionSheetDelegate, JSQMessagesComposerTextViewPasteDelegate, FRPrivateChatViewInterface>

@property (nonatomic, strong) id<FRPrivateChatModuleInterface> eventHandler;
@property (nonatomic, weak) FREvent* eventForChat;
@property (nonatomic, assign) BOOL willShowEventPreview;

- (void)closePressed:(UIBarButtonItem *)sender;

@end
