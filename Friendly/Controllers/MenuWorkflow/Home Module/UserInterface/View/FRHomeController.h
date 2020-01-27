//
//  FRHomeInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 01.07.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "BSTableController.h"
#import "FREventsCellViewModel.h"

@class FRHomeDataSource;


@protocol FRHomeControllerDelegate <NSObject>

- (void)changePositionY:(CGFloat)y;
- (void)friendsEventSelected;
- (void)addFriends;
- (void)updateOldEvent;

@end

@interface FRHomeController : NSObject

@property (nonatomic, weak) id<FRHomeControllerDelegate, FREventsCellViewModelDelegate> delegate;

- (instancetype)initWithTableView:(UITableView*)tableView;
@property (nonatomic, readonly, strong) NSArray* events;

- (NSPredicate*)predicateWithFilter:(NSSortDescriptor **)sort;

@end
