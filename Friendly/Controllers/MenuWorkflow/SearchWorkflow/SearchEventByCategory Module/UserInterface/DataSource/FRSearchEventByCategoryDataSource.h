//
//  FRSearchEventByCategoryInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 24.04.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FREventModel.h"

@class BSMemoryStorage;


@protocol FRSearchEventByCategoryDataSourceDelegate <NSObject>

- (void)userPhotoSelected:(NSString*)userId;
- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREventModel*)event;
- (void)settingSelected;
- (void)shareEvent:(FREvent*)event;
- (void)showEventPreviewWithEvent:(FREvent *)event fromFrame:(CGRect)fram;
- (void)showUserProfile:(UserEntity*)user;

@end

@interface FRSearchEventByCategoryDataSource : NSObject

@property (nonatomic, strong) BSMemoryStorage* storage;
@property (nonatomic, weak) id<FRSearchEventByCategoryDataSourceDelegate> delegate;
@property (nonatomic, weak) UITableView* tableView;
@property (strong, nonatomic) NSArray* events;

- (void)setupStorage;
- (void)updateStorageWithEvents:(NSArray*)eventList users:(NSArray*)users;
- (void)reloadModel:(FREventModel*)event;


@end
