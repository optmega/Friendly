//
//  FRPrivateRoomChatInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRPrivateRoomChatWireframe.h"
#import "FRPrivateRoomChatInteractor.h"
#import "FRPrivateRoomChatVC.h"
#import "FRPrivateRoomChatPresenter.h"
#import "FRInviteToEventViewController.h"
#import "FRUserProfileWireframe.h"

@interface FRPrivateRoomChatWireframe ()

@property (nonatomic, weak) FRPrivateRoomChatPresenter* presenter;
@property (nonatomic, weak) FRPrivateRoomChatVC* privateRoomChatController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRPrivateRoomChatWireframe

- (void)presentPrivateRoomChatControllerFromNavigationController:(UIViewController*)nc userEntity:(UserEntity*)user
{
    UserEntity* userFromContext = [[NSManagedObjectContext MR_defaultContext] objectWithID:user.objectID];
    
    FRPrivateRoomChatVC* privateRoomChatController = [FRPrivateRoomChatVC new];
    FRPrivateRoomChatInteractor* interactor = [FRPrivateRoomChatInteractor new];
    FRPrivateRoomChatPresenter* presenter = [FRPrivateRoomChatPresenter new];
    
    interactor.output = presenter;
    
    privateRoomChatController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;

    
    [presenter configurePresenterWithUserInterface:privateRoomChatController userEntity:userFromContext];
    
    UINavigationController* navControler = [[UINavigationController alloc]initWithRootViewController:privateRoomChatController];
    
    self.presenter = presenter;
    self.presentedController = (UINavigationController*)nc;
    self.privateRoomChatController = privateRoomChatController;
    
    BSDispatchBlockToMainQueue(^{
        //        [nc pushViewController:privateChatController animated:YES];
        
        [nc presentViewController:navControler animated:YES completion:nil];
    });
        
    
}

- (void)dismissPrivateRoomChatController
{
    [self.presentedController dismissViewControllerAnimated:true completion:nil];
}

- (void)presentInviteToEventController:(NSString*)userId
{
    FRInviteToEventViewController* inviteToEventVC = [FRInviteToEventViewController new];
    inviteToEventVC.userId = userId;
    [self.privateRoomChatController presentViewController:inviteToEventVC animated:YES completion:nil];
}

- (void)presentUserProfile:(UserEntity*)user {
    
    FRUserProfileWireframe* uwf = [FRUserProfileWireframe new];

    [uwf presentUserProfileFromViewController:self.privateRoomChatController user:user fromLoginFlow:true];
}

@end
