//
//  FRCreateEventInviteFriendsInputView.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 21.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRCreateEventBaseInpute.h"
#import "FRVCWithOpacity.h"
#import "FRCreateEventInviteFriendsSearchView.h"
#import "FRCreateEventInviteFriendsFacebookButton.h"
#import "FREvent.h"

@protocol FRCreateEventInviteFriendsViewControllerDelegate <NSObject>

- (void)selectedFriends:(NSArray*)friends withIdArray:(NSArray*)friendsId;

@end

@interface FRCreateEventInviteFriendsViewController : FRVCWithOpacity

@property (nonatomic, strong) UILabel* titleLabel;
@property (strong, nonatomic) FRCreateEventInviteFriendsFacebookButton* inviteFBButton;


@property (strong, nonatomic) UICollectionView* friendsCollectionView;
@property (assign, nonatomic) NSInteger* counter;
@property (strong, nonatomic) UITextField* messageField;
@property (strong, nonatomic) FRCreateEventInviteFriendsSearchView* searchView;
@property (strong, nonatomic) FRCreateEventBaseInpute* inviteFriendsView;
@property (weak, nonatomic) id<FRCreateEventInviteFriendsViewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isVCForCreating;
@property (strong, nonatomic) NSMutableArray* friendsArray;
@property (copy, nonatomic) NSString* eventId;

-(void)updateWithEventId:(NSString*)eventId andEvent:(FREvent*)event;
+ (void)openInviteDialogFromVC:(UIViewController*)viewController delegate:(id)delegate;

@end
