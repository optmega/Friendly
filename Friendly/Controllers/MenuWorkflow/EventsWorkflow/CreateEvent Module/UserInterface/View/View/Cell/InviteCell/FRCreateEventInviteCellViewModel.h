//
//  FRCreateEventInviteCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 09.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@class FRCreateEventInviteCellViewModel, FREventFeatureModel;

typedef NS_ENUM(NSInteger, FRCreateEventIvntiteType) {
    FRCreateEventIvntiteTypeCannotFeatured,
    FRCreateEventIvntiteTypeCanFeatured,
    FRCreateEventIvntiteTypeCancelFeaured,
};

@protocol FRCreateEventInviteCellViewModelDelegate <NSObject>

- (void)deleteEvent;
- (void)pressInvite;
- (void)pressFeature:(FRCreateEventInviteCellViewModel*)model;

@end

@interface FRCreateEventInviteCellViewModel : NSObject

@property (assign, nonatomic, readonly) CGFloat heightCell;
@property (assign, nonatomic) BOOL isForEditing;
@property (weak, nonatomic) id<FRCreateEventInviteCellViewModelDelegate> delegate;
@property (nonatomic, assign) FRCreateEventIvntiteType featuredMode;
@property (nonatomic, strong) FREventFeatureModel* fetureModel;

- (void)deleteEvent;
- (void)selectedInvite;
- (void)selectedFeature;
- (void)updatePhoto:(UIImageView*)photo;
- (NSAttributedString*)inviteTitle;

@end
