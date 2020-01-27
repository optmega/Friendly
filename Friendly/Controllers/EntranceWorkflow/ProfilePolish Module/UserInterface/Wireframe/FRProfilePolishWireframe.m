//
//  FRProfilePolishInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 3.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRProfilePolishWireframe.h"
#import "FRProfilePolishInteractor.h"
#import "FRProfilePolishVC.h"
#import "FRProfilePolishPresenter.h"
#import "FRHomeScreenWireframe.h"
#import "FRPhotoPickerController.h"
#import "InstagramSimpleOAuthViewController.h"
#import "InstagramLoginResponse.h"
#import "FRSocialTransport.h"
#import "FRUserManager.h"
#import "SimpleAuth.h"

@interface FRProfilePolishWireframe ()

@property (nonatomic, weak) FRProfilePolishPresenter* presenter;
@property (nonatomic, weak) FRProfilePolishVC* profilePolishController;
@property (nonatomic, weak) UINavigationController* presentedController;
@property (nonatomic, strong) FRPhotoPickerController* pickerController;

@end

@implementation FRProfilePolishWireframe

- (void)presentProfilePolishControllerFromNavigationController:(UINavigationController*)nc interests:(NSArray*)interests
{
    FRProfilePolishVC* profilePolishController = [FRProfilePolishVC new];
    FRProfilePolishInteractor* interactor = [FRProfilePolishInteractor new];
    FRProfilePolishPresenter* presenter = [FRProfilePolishPresenter new];
    
    interactor.output = presenter;
    profilePolishController.eventHandler = presenter;
    presenter.interactor = interactor;
    presenter.wireframe = self;
    [presenter configurePresenterWithUserInterface:profilePolishController interests:interests];
    
    BSDispatchBlockToMainQueue(^{
        [nc pushViewController:profilePolishController animated:NO];
    });
    
    self.presenter = presenter;
    self.presentedController = nc;
    self.profilePolishController = profilePolishController;
}

- (void)dismissProfilePolishController
{
    [self.presentedController popViewControllerAnimated:NO];
}

- (void)presentHomeScreen
{
//    self.presentedController.viewControllers = @[];
    [[FRHomeScreenWireframe new] presentHomeScreenControllerFromNavigationController:self.presentedController];
}

- (void)presentPhotoPickerController
{
    self.pickerController = [[FRPhotoPickerController alloc] initWithViewController:self.profilePolishController];
    self.pickerController.quality = 0.6;
    self.pickerController.delegate = (id<FRPhotoPickerControllerDelegate>)self.presenter;
}

- (void)presentInstagramAuthController
{
    
    NSString *provider = @"instagram";
    SimpleAuth.configuration[@"instagram"] = @{
                                               @"client_id" : kClientID,
                                               SimpleAuthRedirectURIKey : @"http://google.com/"
                                               };
    //    if ([configuration count] == 0) {
    //        NSLog(@"It looks like you haven't configured the \"%@\" provider.\n"
    //              "Consider calling +[SimpleAuth configuration] in `application:willFinishLaunchingWithOptions: "
    //              "and providing all relevant options for the given provider.",
    //              provider);
    //        return;
    //    }
    __block NSString* token = @"";
    [SimpleAuth authorize:provider completion:^(id responseObject, NSError *error) {
        NSLog(@"\nResponse: %@\nError:%@", responseObject, error);
        NSDictionary* response = (NSDictionary*)responseObject;
        if (response)
        {
            NSDictionary* cred = [response objectForKey:@"credentials"];
            if (cred)
            {
                token = (NSString*)[cred objectForKey:@"token"];
                [FRUserManager sharedInstance].instaToken = token;
                [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"instaToken"];
                [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
                    //
                } failure:^(NSError *error) {
                    //
                }];
                
                
            }
        }
        
    }];
    

//        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
//        [[storage cookies] enumerateObjectsUsingBlock:^(NSHTTPCookie *cookie, NSUInteger idx, BOOL *stop) {
//            [storage deleteCookie:cookie];
//        }];
    
//        InstagramSimpleOAuthViewController *viewController = [[InstagramSimpleOAuthViewController alloc] initWithClientID:kClientID                                                                                clientSecret:@"dab460cb3f574da38507676960ad7ac2"
//                                                                           callbackURL:[NSURL URLWithString:@"http://google.com"]
//                                                                            completion:^(InstagramLoginResponse *response, NSError *error) {
//                                                                                NSLog(@"My Access Token is:  %@", response.accessToken);
//                                                                                [FRUserManager sharedInstance].instaToken = response.accessToken;
//                                                                                [[NSUserDefaults standardUserDefaults] setObject:response.accessToken forKey:@"instaToken"];
//                                                                                [FRSocialTransport signInWithInstagram:[FRUserManager sharedInstance].instaToken                                   success:^(NSArray *images) {
//                                                                                    //
//                                                                                } failure:^(NSError *error) {
//                                                                                    //
//                                                                                }];
//                                                                            }];
//
//    [self.presentedController setNavigationBarHidden:NO animated:NO];
//    [self.presentedController pushViewController:viewController
//                                             animated:YES];
}


@end
