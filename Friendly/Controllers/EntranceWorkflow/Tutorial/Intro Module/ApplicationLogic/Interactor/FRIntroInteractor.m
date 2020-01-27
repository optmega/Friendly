//
//  FRIntroInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRIntroInteractor.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "FRAuthTransportService.h"
#import "FRUserManager.h"


@implementation FRIntroInteractor

- (void)loadData
{
    [self.output dataLoaded];
}

- (void)login:(UIViewController*)viewController
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];

    [login logOut];
    [self.output showHudWithType:FRIntroHudTypeShowHud title:nil message:nil];
    
    [login logInWithReadPermissions: @[@"public_profile", @"user_friends", @"email", @"user_birthday"]
                 fromViewController:viewController
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                
                if (error)
                {
                    [self.output showHudWithType:FRIntroHudTypeError title:@"Error" message:error.localizedDescription];
                }
                else if (result.isCancelled)
                {
                    [self.output showHudWithType:FRIntroHudTypeHideHud title:nil message:nil];
                }
                else
                {
                    [self.output fbLoginSuccess];
                    [FRAuthTransportService authWithFacebookToken:[FBSDKAccessToken currentAccessToken].tokenString
                                                        apnsToken:[FRUserManager sharedInstance].apnsToken
                                                          success:^(FRUserModel* response) {
                                                            NSLog(@"%@", response);
                                                            [self.output showHudWithType:FRIntroHudTypeHideHud title:nil message:nil];
                                                              [self.output loginSuccess:response.first_login];
                                                              [[FRWebSoketManager shared] connect];
                    } failure:^(NSError *error) {
                         [self.output showHudWithType:FRIntroHudTypeError title:@"Error" message:error.localizedDescription];
                        [self.output loginFailure];
                    }];
                }
    }];
}


@end


