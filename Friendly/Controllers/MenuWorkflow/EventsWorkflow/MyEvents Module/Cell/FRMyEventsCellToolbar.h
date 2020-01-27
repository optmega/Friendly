//
//  FRMyEventsCellToolbar.h
//  Friendly
//
//  Created by Jane Doe on 3/18/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCellViewModel.h"
#import "FREvent.h"

@protocol FRMyEventsCellToolbarDelegate <NSObject>


- (void) editEvent:(FREvent*)event;
- (void) guestsSelectWithUser:(NSMutableArray*)users andEvent:(NSString*)eventId;;
- (void) moreSelectWithEvent:(NSString*)eventId andModel:(FREvent*)model;
- (void) showInviteWithEvent:(NSString*)eventId andEvent:(FREvent*)model;
- (void) leaveEvent:(NSString*)eventId;
- (void) shareEvent:(FREvent*)event;
- (void) showChatForEvent:(FREvent*)event;

@end

@interface FRMyEventsCellToolbar : UIToolbar

- (void)updateWithType:(FRMyEventsCellType)type;
- (void)updateWithEvent:(FREvent*)eventModel andUsers:(NSArray*)users;

@property (weak, nonatomic) id<FRMyEventsCellToolbarDelegate> cellToolBarDelegate;

@end
