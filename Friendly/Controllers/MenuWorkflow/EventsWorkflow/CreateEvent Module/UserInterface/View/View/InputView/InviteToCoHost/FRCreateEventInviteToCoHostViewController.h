//
//  FRCreateEventInviteToCoHostViewController.h
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventInviteFriendsViewController.h"

@protocol FRCreateEventInviteToCoHostViewControllerDelegate <NSObject>

- (void) selectedPartnerWithId:(NSString*)partnerId andName:(NSString*)partnerName;

@end


@interface FRCreateEventInviteToCoHostViewController : FRCreateEventInviteFriendsViewController

@property (weak, nonatomic) id<FRCreateEventInviteToCoHostViewControllerDelegate> selectPartnerDelegate;

@end
