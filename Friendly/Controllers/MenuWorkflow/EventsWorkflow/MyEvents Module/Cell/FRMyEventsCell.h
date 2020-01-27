//
//  FRMyEventCell.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 17.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRMyEventsCellViewModel.h"
#import "FRMyEventsCellToolbar.h"
#import "FRMyEventsDateView.h"

@protocol FRMyEventsCellDelegate <NSObject>

//- (void) guestsSelectWithUser:(NSMutableArray*)users andEvent:(NSString*)eventId;;
//- (void) moreSelectWithEvent;
//- (void) showInvite;

-(void)showEventBySelectingRowWithModel:(FREvent*)model fromCell:(UITableViewCell*)cell;
-(void)presentShareEventControllerWithModel:(FREventModel*)model;

@end

@interface FRMyEventsCell : UITableViewCell

- (void) updateWithModel:(FRMyEventsCellViewModel*)model;
- (void) updateEventImage:(UIImage*)eventImage;
@property (strong, nonatomic) FRMyEventsCellToolbar* footerView;
@property (weak, nonatomic) id<FRMyEventsCellDelegate> delegate;
@property (strong, nonatomic) FRMyEventsDateView* dateView;
@property (strong, nonatomic, readonly) UIImageView* headerView;


@end
