//
//  FRMyEventsMoreViewController.h
//  Friendly
//
//  Created by Jane Doe on 3/28/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRVCWithOpacity.h"
#import "FREvent.h"

@protocol FRMyEventsMoreViewControllerDelegate <NSObject>

-(void)updateData;

@end

@interface FRMyEventsMoreViewController : FRVCWithOpacity

-(void)updateWithEventId:(NSString*)eventId andModel:(FREvent*)model;

@property (weak, nonatomic) NSObject<FRMyEventsMoreViewControllerDelegate>* delegate;

@end
