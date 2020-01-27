//
//  FRSearchByCategoryMapCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 26.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventModel.h"

@protocol FRSearchByCategoryMapCellViewModelDelegate <NSObject>

- (void)selectedShowFullScreen;
- (void)showEventPreviewWithEvent:(FREvent *)event;
- (void)showUserProfile:(UserEntity*)user;

@end

@interface FRSearchByCategoryMapCellViewModel : NSObject

@property (nonatomic, weak) id<FRSearchByCategoryMapCellViewModelDelegate> delegate;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) NSArray* markersArray;
@property (nonatomic, strong) NSArray* events;

- (CGFloat)heightCell;
- (void)pressShowFullScreen:(BOOL)isSelected;
- (void)showEventPreviewWithEvent:(FREvent*)event;
- (void)showUserProfile:(UserEntity*)user;

@end
