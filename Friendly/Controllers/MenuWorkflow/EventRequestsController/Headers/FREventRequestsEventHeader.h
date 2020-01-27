//
//  FREventRequestsEventHeader.h
//  Friendly
//
//  Created by Jane Doe on 4/4/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FREventRequestsToJoinHeaderModel.h"

@protocol FREventRequestsEventHeaderDelegate <NSObject>

-(void)showEventWithModel:(FREvent*)model;

@end

@interface FREventRequestsEventHeader : UITableViewHeaderFooterView

- (void) updateWithModel:(FREventRequestsToJoinHeaderModel*)model;
@property (weak, nonatomic) id<FREventRequestsEventHeaderDelegate> delegate;

@end
