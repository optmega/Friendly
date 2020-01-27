//
//  FREventsCellViewModel.h
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


@class FREventModel, FREventsCellViewModel;
#import "FREvent.h"

@protocol FREventsCellViewModelDelegate <NSObject>

- (void)userPhotoSelected:(NSString*)userId;
- (void)joinSelectedWithEventId:(NSString*)eventId andModel:(FREvent*)event;
- (void)selectedShareEvent:(FREvent*)eventId;
- (void)partnerPhotoSelected:(NSString*)partnerId;
- (void)selectedEvent:(FREventsCellViewModel*)viewModel;


@end

@interface FREventsCellViewModel : NSObject

@property (nonatomic, strong) id<FREventsCellViewModelDelegate>delegate;
@property (nonatomic, strong) NSString* creatorPhoto;
@property (nonatomic, weak) UITableViewCell* cell; // нужно исключительно для быстрого определения indexPath, решение не очень хорошее, но в силу сжатых сроков сойдет

//+ (instancetype)initWithModel:(FREvent*)model;

+ (instancetype)initWithEvent:(FREvent*)event;

- (void)updateUserPhoto:(UIImageView*)userPhoto;
- (void)updatePartnerPhoto:(UIImageView*)userPhoto;
- (void)updateEventPhoto:(UIImageView*)eventPhoto tempImage:(UIImageView*)temp;

- (FREvent*)domainModel;
- (void)userPhotoSelected;
- (void)partnerPhotoSelected;
- (void)joinEventSelected;
- (NSString*)distance;
- (void)selectedShare;
- (void)selectedEvent;

@end
