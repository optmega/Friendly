//
//  FREventPreviewController.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 10.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRBaseVC.h"
#import "FREvent.h"

@class FREvent;

@protocol FREventPreviewControllerDelegate <NSObject>

- (void)moveBackAndShowVC;

@end

@interface FREventPreviewController : FRBaseVC

//- (instancetype)initWithEventId:(NSString*)eventId andModel:(FREventModel*)model;
- (instancetype)initWithEvent:(FREvent*)event fromFrame:(CGRect) frame;


@property (nonatomic, weak) UIViewController* temp;

@property (weak, nonatomic) id<FREventPreviewControllerDelegate> delegate;
@property (assign, nonatomic) BOOL isHostingEvent;
@property (nonatomic, strong) UIImage* eventImage;
@property (nonatomic, assign) BOOL isAttendingStatus;

@property (strong, nonatomic) FREvent* event;
@property (nonatomic, assign) BOOL isFromEvent;

@property (nonatomic, copy) BSCodeBlock complite;

@end
