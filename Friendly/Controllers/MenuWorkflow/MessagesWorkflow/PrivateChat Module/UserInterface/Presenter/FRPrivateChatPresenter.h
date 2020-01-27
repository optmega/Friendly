//
//  FRPrivateChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.05.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateChatInteractorIO.h"
#import "FRPrivateChatWireframe.h"
#import "FRPrivateChatViewInterface.h"
#import "FRPrivateChatModuleDelegate.h"
#import "FRPrivateChatModuleInterface.h"

@interface FRPrivateChatPresenter : NSObject <FRPrivateChatInteractorOutput, FRPrivateChatModuleInterface>

@property (nonatomic, strong) id<FRPrivateChatInteractorInput> interactor;
@property (nonatomic, strong) FRPrivateChatWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRPrivateChatViewInterface>* userInterface;
@property (nonatomic, weak) id<FRPrivateChatModuleDelegate> privateChatModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRPrivateChatViewInterface>*)userInterface event:(FREvent*)event;

@end
