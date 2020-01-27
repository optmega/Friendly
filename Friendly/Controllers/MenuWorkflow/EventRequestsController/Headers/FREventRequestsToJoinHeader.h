//
//  FREventRequestsToJoinHeader.h
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventRequestsToJoinHeaderModel.h"

@protocol FREventRequestsToJoinHeaderDelegate <NSObject>

-(void)showEventWithModel:(FREvent*)model;

@end

@interface FREventRequestsToJoinHeader : UITableViewHeaderFooterView

- (void) updateWithModel:(FREventRequestsToJoinHeaderModel*)model;
@property (weak, nonatomic) id<FREventRequestsToJoinHeaderDelegate> delegate;

@end
