//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventsVC, FREventModel, FRShowEventsParentVC;

@interface FREventsWireframe : NSObject

- (void)presentEventsControllerFromNavigationController:(UINavigationController*)nc;
- (void)dismissEventsController;

- (void)presentProfileController;
- (void)presentPreviewControllerWithEvent:(FREventModel*)event image:(UIImage*)imageEvent;
- (void)presentProfileUserControlletWithUserId:(NSString*)userId;
- (void)presentJoinController:(NSString*)eventId;
- (void)presentFilterController;
- (void)presentShareControllerWithEvent:(FREventModel*)event;

@property (nonatomic, weak) FREventsVC* eventsController;
@property (nonatomic, strong) FRShowEventsParentVC* ppp;

@end
