//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

@class FRFriendsEventsDataSource;

@protocol FRFriendsEventsViewInterface <NSObject>

- (void)updateDataSource:(FRFriendsEventsDataSource*)dataSource;
- (void)updatedEvents;

@end
