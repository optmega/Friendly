//
//  FREventListCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREventModel;

@protocol FREventListCellViewModelDelegate <NSObject>

- (void)pressUserPhoto:(NSString*)userId;
- (void)selectedJointEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)selectedShareEvent:(FREvent*)eventId;

@end

@interface FREventListCellViewModel : NSObject

@property (nonatomic, weak) id<FREventListCellViewModelDelegate>delegate;

@property (nonatomic, strong) NSArray* list;

- (void)pressUserPhoto:(NSString*)userId;
- (void)pressJoinEventId:(NSString*)eventId andModel:(FREventModel*)event;
- (void)selectedShareEvent:(FREventModel*)event;

@end
