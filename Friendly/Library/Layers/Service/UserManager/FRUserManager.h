//
//  FRUserManager.h
//  Friendly
//
//  Created by Sergey Borichev on 07.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRUserModel.h"
#import "CurrentUser.h"

@interface FRUserManager : NSObject

@property (nonatomic, strong) UIImage* testImage;
@property (nonatomic, strong) NSString* apnsToken;
@property (nonatomic, assign) NSInteger eventRequestsCount;
@property (nonatomic, strong) NSString* instaToken;
@property (nonatomic, strong) FRUserModel* userModel;
@property (nonatomic, assign) BOOL available_for_meet;
@property (nonatomic, assign) NSInteger friendsRequestCount;
@property (nonatomic, assign) NSInteger newMessageCount;

@property (nonatomic, assign) BOOL canShowAdvertisement;

@property (nonatomic, strong) NSString* openRoomId;
@property (nonatomic, strong) NSString* currentChatGroupId;

@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSArray* friends;
@property (nonatomic, strong) UIImage* normalEventImage;
@property (nonatomic, strong) UIImage* logoImage;
@property (nonatomic, strong) UIImage* avatarPlaceholder;
@property (nonatomic, strong) UIImage* currentUserPhoto;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

@property (nonatomic, weak) UIView* temp;

+ (instancetype)sharedInstance;

- (void)udpateFriendsRequest;
- (CurrentUser*)currentUser;
@end
