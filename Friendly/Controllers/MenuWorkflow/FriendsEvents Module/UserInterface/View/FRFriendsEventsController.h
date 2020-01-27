//
//  FRFriendsEventsInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 03.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"
#import "FREventsCellViewModel.h"


@protocol FRFriendsEventsControllerDelegate <NSObject>

- (void)selectedFriendsInvite;
- (void)updateOldEvent;

@end

@interface FRFriendsEventsController : NSObject

@property (nonatomic, weak) id<FRFriendsEventsControllerDelegate, FREventsCellViewModelDelegate> delegate;

- (instancetype)initWithTableView:(UITableView *)tableView;

@end
