//
//  FREventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 29.02.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class BSMemoryStorage, FREventModel, FREventModels, FRFriendEventsModel;


@protocol FREventsDataSourceDelegate <NSObject>

- (void)showUserProfile:(NSString*)userId;
- (void)joinEventViewSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)shareEvent:(FREvent*)model;

@end

@interface FREventsDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FREventsDataSourceDelegate> delegate;

- (void)setupStorage;
- (void)featuredModelsUpdate:(FREventModels*)list;
- (void)friendEventsUpdate:(FRFriendEventsModel*)eventModel;

@end
