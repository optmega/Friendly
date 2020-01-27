//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRFriendsEventsInteractorIO.h"
#import "FRFriendsEventsWireframe.h"
#import "FRFriendsEventsViewInterface.h"
#import "FRFriendsEventsModuleDelegate.h"
#import "FRFriendsEventsModuleInterface.h"

@interface FRFriendsEventsPresenter : NSObject <FRFriendsEventsInteractorOutput, FRFriendsEventsModuleInterface>

@property (nonatomic, strong) id<FRFriendsEventsInteractorInput> interactor;
@property (nonatomic, strong) FRFriendsEventsWireframe* wireframe;

@property (nonatomic, weak) UIViewController<FRFriendsEventsViewInterface>* userInterface;
@property (nonatomic, weak) id<FRFriendsEventsModuleDelegate> friendsEventsModuleDelegate;

- (void)configurePresenterWithUserInterface:(UIViewController<FRFriendsEventsViewInterface>*)userInterface;

@end
