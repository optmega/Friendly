//
//  FRSearchDiscoverPeopleInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 19.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRSearchDiscoverPeopleWireframe.h"
#import "FRSearchDiscoverPeopleInteractor.h"
#import "FRSearchDiscoverPeopleVC.h"
#import "FRSearchDiscoverPeoplePresenter.h"
#import "FRUserProfileWireframe.h"
#import "FRRecommendedUsersWireframe.h"
#import "FRSettingsTransport.h"
#import <FBSDKShareKit/FBSDKAppInviteContent.h>
#import <FBSDKShareKit/FBSDKAppInviteDialog.h>

@interface FRSearchDiscoverPeopleWireframe () <FBSDKAppInviteDialogDelegate>

@property (nonatomic, weak) FRSearchDiscoverPeoplePresenter* presenter;
@property (nonatomic, weak) FRSearchDiscoverPeopleVC* searchDiscoverPeopleController;
@property (nonatomic, weak) UINavigationController* presentedController;

@end

@implementation FRSearchDiscoverPeopleWireframe

- (void)presentSearchDiscoverPeopleControllerFromNavigationController:(UINavigationController*)nc tag:(NSString*)tag
{
    FRSearchDiscoverPeopleVC* searchDiscoverPeopleController = [FRSearchDiscoverPeopleVC new];
    FRSearchDiscoverPeopleInteractor* interactor = [FRSearchDiscoverPeopleInteractor new];
    FRSearchDiscoverPeoplePresenter* presenter = [FRSearchDiscoverPeoplePresenter new];
    
    interactor.output = presenter;
    
    searchDiscoverPeopleController.eventHandler = presenter;
    
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:searchDiscoverPeopleController tag:tag];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:searchDiscoverPeopleController animated:YES];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.searchDiscoverPeopleController = searchDiscoverPeopleController;
}

- (void)dismissSearchDiscoverPeopleController
{
    [self.presentedController popViewControllerAnimated:YES];
}

- (void)presentUserProfile:(UserEntity*)user
{
    [[FRUserProfileWireframe new]presentUserProfileFromViewController:self.searchDiscoverPeopleController user:user fromLoginFlow:false];
    
    //TODO: нужно передавать UserEntity
//    [[FRUserProfileWireframe new] presentUserProfileControllerFromNavigationController:self.presentedController userId:userId];
}

- (void)presentRecomendedUsersFromNavigationController:(UINavigationController*)nc
{   [FRSettingsTransport getInviteUrl:^(NSString *url) {
    
    FBSDKAppInviteContent *content = [[FBSDKAppInviteContent alloc] init];
    content.appLinkURL = [NSURL URLWithString:[NSObject bs_safeString:url]];
    content.appInvitePreviewImageURL = [NSURL URLWithString:@"http://image.prntscr.com/image/d6d9e0d621b44c32a4c005d19d069652.png"];
    [FBSDKAppInviteDialog showFromViewController:self.searchDiscoverPeopleController
                                     withContent:content
                                        delegate:self];
    
} failure:^(NSError *error) {
    NSLog(@"Error - %@", error.localizedDescription);
}];

//    [[FRRecommendedUsersWireframe new] presentAddFriendsControllerFrom:nc];
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didCompleteWithResults:(NSDictionary *)results
{
    
}

- (void)appInviteDialog:(FBSDKAppInviteDialog *)appInviteDialog didFailWithError:(NSError *)error
{
    NSLog(@"%@", error.localizedDescription);
}

@end
