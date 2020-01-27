//
//  FRMessagerInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 16.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"

@class FRMessagerDataSource;


@interface FRMessagerController : NSObject

- (void)updateWithTableView:(UITableView*)tableView;
- (void)updateDataSource:(FRMessagerDataSource*)dataSource;
- (void)updateChats:(NSArray*)chats;
- (void)updateForSearch:(NSString*)searchString;
- (NSInteger)currentRoomsCount;

@end
