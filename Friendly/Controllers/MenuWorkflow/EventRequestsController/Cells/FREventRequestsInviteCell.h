//
//  FREventRequestsInviteCell.h
//  Friendly
//
//  Created by Jane Doe on 4/7/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRInviteModel.h"

@protocol FREventRequestsInviteCellDelegate <NSObject>

-(void)joinEventWithId:(NSString*)eventId andModel:(FREvent*)model;
-(void)declineEventWithId:(NSString*)eventId;
-(void)acceptPartnerForEventId:(NSString*)eventId;
-(void)declinePartnerForEventId:(NSString*)eventId;
-(void)acceptInviteWithId:(NSString*)inviteId;
-(void)showEventWithModel:(FREvent*)model;
-(void)showUserProfileWithEntity:(UserEntity*)user;

@end

@interface FREventRequestsInviteCell : UITableViewCell

-(void) updateWithModel:(FRInviteModel*)model;
-(void) updateWithInvitePartnerModel:(FRInviteToPartnerModel*)model;

@property (weak, nonatomic) NSObject<FREventRequestsInviteCellDelegate>* delegate;
-(void) updateWithInviteToCoHost;

@end
