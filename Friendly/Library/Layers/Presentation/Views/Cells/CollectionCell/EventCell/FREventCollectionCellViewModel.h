//
//  FREventCollectionCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

@class FREventModel;

@protocol FREventCollectionCellViewModelDelegate <NSObject>

- (void)pressUserPhoto:(NSString*)userId;
- (void)pressJoinEventId:(NSString*)eventId;
- (void)selectedShareEvent:(FREvent*)event;
- (void)selectedJointEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)pressJoinEventId:(NSString*)eventId andModel:(FREvent*)event;

@end

@interface FREventCollectionCellViewModel : NSObject

@property (nonatomic, weak) id<FREventCollectionCellViewModelDelegate>delegate;
+ (instancetype)initWithModel:(FREvent*)model;


- (FREvent*)domainModel;
- (void)pressUserPhoto;

- (void)pressJoin;
- (void)pressArrow;

- (void)updateUserPhoto:(UIImageView*)userPhoto;
- (void)updateEventPhoto:(UIImageView*)eventPhoto;
- (NSString*)distance;

@end
