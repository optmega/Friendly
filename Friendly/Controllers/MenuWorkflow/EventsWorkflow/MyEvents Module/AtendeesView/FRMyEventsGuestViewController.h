//
//  FRMyEventsGuestView.h
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FRVCWithOpacity.h"
#import "FRMyEventGuestViewModel.h"
#import "FREvent.h"

@protocol FRMyEventsGuestViewControllerDelegate <NSObject>

- (void) showInviteWithEvent:(NSString*)eventId andEvent:(FREvent *)event;

@end

@interface FRMyEventsGuestViewController : FRVCWithOpacity

@property (nonatomic, strong) NSMutableArray* users;
@property (nonatomic, strong) NSString* eventId;
@property (nonatomic, strong) FREvent* event;

-(void) updateWithHostingType;
@property (nonatomic, weak) id<FRMyEventsGuestViewControllerDelegate> delegate;

@end
