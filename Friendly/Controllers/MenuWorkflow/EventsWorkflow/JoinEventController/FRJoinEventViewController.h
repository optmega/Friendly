//
//  JoinEventViewController.h
//  Friendly
//
//  Created by Jane Doe on 3/24/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRVCWithOpacity.h"
#import "FREvent.h"

@protocol FRJoinEventViewControllerDelegate <NSObject>

-(void) updateRequestStatus;
-(void) updateRequestStatusWithModel:(FREvent*)event;
//- (void)reloadData;

@end


@interface FRJoinEventViewController : FRVCWithOpacity

-(void)updateWithEventId:(NSString*)eventId;
-(void)updateWithEvent:(FREvent*)event;
@property (weak, nonatomic) id<FRJoinEventViewControllerDelegate> delegate;
@property (nonatomic, strong) MASConstraint* heightConstraint;
@property (nonatomic, strong) MASConstraint* iconHeightConstraint;
@end
