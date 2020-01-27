//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FREventModels, FRFriendEventsModel;

#import "FRSegmentView.h"

typedef NS_ENUM(NSInteger, FREventsHudType) {
    FREventsHudTypeError,
    FREventsHudTypeShowHud,
    FREventsHudTypeHideHud,
};

@protocol FREventsInteractorInput <NSObject>

- (void)loadData;
- (void)updateEvents;
- (void)updateEventsWithType:(FRSegmentType)type;

@end


@protocol FREventsInteractorOutput <NSObject>

- (void)dataLoaded;
- (void)featuredEventsLoaded:(FREventModels*)eventsModel;
- (void)friendEventsLoaded:(FRFriendEventsModel*)eventModel;
- (void)showHudWithType:(FREventsHudType)type title:(NSString*)title message:(NSString*)message;

@end