//
//  FREventCollectionCellViewModel.m
//  Friendly
//
//  Created by Sergey Borichev on 14.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventCollectionCellViewModel.h"
#import "FREventModel.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"

@interface FREventCollectionCellViewModel ()

@property (nonatomic, strong) FREventModel* model;

@end

@implementation FREventCollectionCellViewModel

+ (instancetype)initWithModel:(FREventModel*)model
{
    FREventCollectionCellViewModel* viewModel = [FREventCollectionCellViewModel new];
    viewModel.model = model;
    
    return viewModel;
}

- (NSString*)distance
{
    return [NSString stringWithFormat:@"%.1fKM AWAY",[self.model.way integerValue]  / 1000.];
}

- (FREventModel*)domainModel
{
    return self.model;
}

- (void)pressUserPhoto
{
    [self.delegate pressUserPhoto:self.model.creator.id];
}

- (void)pressJoin
{
    [self.delegate pressJoinEventId:self.model.id andModel:self.model];
}

- (void)pressArrow
{
    [self.delegate selectedShareEvent:self.model];
}

- (void)updateUserPhoto:(UIImageView*)userPhoto
{
    NSURL* url = [NSURL URLWithString:self.model.creator.photo];
    [userPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            userPhoto.image = image;
        }
    }];
}

- (void)updateEventPhoto:(UIImageView*)eventPhoto
{
    NSURL* url = [NSURL URLWithString:self.model.image_url];
    [eventPhoto sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image)
        {
            eventPhoto.image = image;
        }
    }];
}

@end
