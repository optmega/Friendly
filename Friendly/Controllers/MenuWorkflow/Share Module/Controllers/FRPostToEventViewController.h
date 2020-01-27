//
//  FRPostToEventViewController.h
//  Friendly
//
//  Created by Jane Doe on 5/6/16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRShareEventViewController.h"

@protocol FRPostToEventViewControllerDelegate <NSObject>

-(void)closeVC;

@end

@interface FRPostToEventViewController : FRShareEventViewController
@property (weak, nonatomic) NSObject<FRPostToEventViewControllerDelegate>* delegate;
@property (nonatomic, strong) NSString* eventId;
@end
