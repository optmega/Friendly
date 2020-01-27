//
//  FRUserProfileFriendActionView.h
//  Friendly
//
//  Created by Sergey Borichev on 31.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


typedef NS_ENUM(NSInteger, FRFriendActionMode) {
    FRFriendActionModeAddFriend,
    FRFriendActionModePending,
    FRFriendActionModeFriend,
};

@protocol FRUserProfileFriendActionViewDelegate <NSObject>

- (void)pendingSelected;
- (void)addFriendSelected;
- (void)inviteToEventSelected;
- (void)friendsSelected;


@end


@interface FRUserProfileFriendActionView : UIView

@property (nonatomic, weak) id<FRUserProfileFriendActionViewDelegate>delegate;

- (void)setMode:(FRFriendActionMode)mode;



@end
