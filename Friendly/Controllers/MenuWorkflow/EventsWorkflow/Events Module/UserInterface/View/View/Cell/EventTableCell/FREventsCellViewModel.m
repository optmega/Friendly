//
//  FREventsCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 11.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventsCellViewModel.h"
#import "FREventModel.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FREventsCellViewModel ()

@property (nonatomic, strong) FREvent* model;

@end




@implementation FREventsCellViewModel

//+ (instancetype)initWithModel:(FREventModel*)model
//{
////    FREventsCellViewModel* viewModel = [FREventsCellViewModel new];
//////    viewModel.model = model;
////    viewModel.creatorPhoto = model.creator.photo;
////    return viewModel;
//}

+ (instancetype)initWithEvent:(FREvent*)event
{
    FREventsCellViewModel* viewModel = [FREventsCellViewModel new];
    viewModel.model = event;
    viewModel.creatorPhoto = event.creator.userPhoto;
    return viewModel;
}



- (NSString*)distance
{
//    NSString* way = [self.model.way integerValue] < 1000 ? [NSString stringWithFormat:@"%ldM", (long)[self.model.way integerValue]] : [NSString stringWithFormat:@"%.1fKM", [self.model.way integerValue] / 1000.];
//    
//    return [NSString stringWithFormat:@"%@ AWAY",way];

    return [NSString stringWithFormat:@"%.1fKM AWAY",[self.model.way integerValue]  / 1000.];
}

- (void)userPhotoSelected
{
    [self.delegate userPhotoSelected:self.model.creator.user_id];
}

- (void)partnerPhotoSelected
{
    [self.delegate partnerPhotoSelected:self.model.partnerHosting];
}

- (void)selectedShare
{
    [self.delegate selectedShareEvent:self.model];
}

- (void)updatePartnerPhoto:(UIImageView*)userPhoto
{
    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.model.partnerUser.photo]];
    [userPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image)
        {
            userPhoto.image = image;
        } else {
            userPhoto.image = [FRStyleKit imageOfDefaultAvatar];
        }
    }];
}

- (void)updateEventPhoto:(UIImageView*)eventPhoto tempImage:(UIImageView*)temp
{
    
        [eventPhoto sd_setImageWithURL:[NSURL URLWithString:self.model.thumbnail_url]
                      placeholderImage:[FRStyleKit imageOfArtboard121Canvas]
                             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image)
            {
                temp.image = image;
                eventPhoto.image = image;
            } else {
                eventPhoto.image = [FRStyleKit imageOfArtboard121Canvas];
//                temp.image = [FRStyleKit imageOfArtboard121Canvas];
            }
            
             [eventPhoto sd_setImageWithURL:[NSURL URLWithString:self.model.imageUrl]
                           placeholderImage:[FRStyleKit imageOfArtboard121Canvas]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      if (image)
                                      {
                                          temp.image = image;
                                          eventPhoto.image = image;
                                      } else {
                                          eventPhoto.image = [FRStyleKit imageOfArtboard121Canvas];
//                                          temp.image = [FRStyleKit imageOfArtboard121Canvas];
                                      }
                                  }];
                            
        }];
    
}

- (void)joinEventSelected
{
    if ([[self.model requestStatus] integerValue] == FREventRequestStatusAvailableToJoin) {

        [self.delegate joinSelectedWithEventId:self.model.eventId andModel:self.model];
    }
}

- (FREvent*)domainModel
{
    return self.model;
}

- (void)updateUserPhoto:(UIImageView*)userPhoto
{
    userPhoto.image = [FRStyleKit imageOfDefaultAvatar];
    NSURL* url = [NSURL URLWithString:self.model.creator.userPhoto];
    [userPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        if (image)
        {
            userPhoto.image = image;
        } else {
            userPhoto.image = [FRStyleKit imageOfDefaultAvatar];
        }
    }];
}

- (void)selectedEvent
{
    [self.delegate selectedEvent:self];
}

@end
