//
//  FREventDomainModel.m
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FREventDomainModel.h"


static const struct
{
    __unsafe_unretained NSString *image_url;
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *info;
    __unsafe_unretained NSString *lat;
    __unsafe_unretained NSString *lon;
    __unsafe_unretained NSString *gender;
    __unsafe_unretained NSString *age_min;
    __unsafe_unretained NSString *age_max;
    __unsafe_unretained NSString *slots;
    __unsafe_unretained NSString *date;
    __unsafe_unretained NSString *time;
    __unsafe_unretained NSString *event_start;
    __unsafe_unretained NSString *show_number;
    __unsafe_unretained NSString *creator_id;
    __unsafe_unretained NSString *category;
    __unsafe_unretained NSString *address;
    __unsafe_unretained NSString *partner_hosting;
    __unsafe_unretained NSString *category_id;
    __unsafe_unretained NSString *open_to_fb_friends;
    __unsafe_unretained NSString *thumbnail_url;
    __unsafe_unretained NSString *isFeature;
    
} FREventParametr =
{
    .image_url          = @"image_url",
    .title              = @"title",
    .info               = @"info",
    .lat                = @"lat",
    .lon                = @"lon",
    .gender             = @"gender",
    .age_min            = @"age_min",
    .age_max            = @"age_max",
    .slots              = @"slots",
    .date               = @"date_",
    .time               = @"time_",
    .event_start        = @"event_start",
    .show_number        = @"show_number",
    .creator_id         = @"creator_id",
    .category           = @"category",
    .address            = @"address",
    .partner_hosting    = @"partner_hosting",
    .category_id        = @"category_id",
    .open_to_fb_friends = @"open_to_fb_friends",
    .thumbnail_url      = @"thumbnail_url",
    .isFeature          = @"is_featured",
};


@implementation FREventDomainModel

- (NSDictionary*)domainModelDictionary
{
    return @{
         FREventParametr.image_url : [NSObject bs_safeString:self.image_url],
             FREventParametr.title : [NSObject bs_safeString:self.title],
              FREventParametr.info : [NSObject bs_safeString:self.info],
               FREventParametr.lat : @(self.lat),
               FREventParametr.lon : @(self.lon),
            FREventParametr.gender : @(self.gender),
           FREventParametr.age_max : @(self.age_max),
           FREventParametr.age_min : @(self.age_min),
             FREventParametr.slots : @(self.slots),
              FREventParametr.date : [NSObject bs_safeString:self.date_],
              FREventParametr.time : [NSObject bs_safeString:self.time_],
       FREventParametr.event_start : [NSObject bs_safeString:self.event_start],
       FREventParametr.show_number : @(self.show_number),
       FREventParametr.show_number : [NSObject bs_safeString:self.creator_id],
          FREventParametr.category : [NSObject bs_safeString:self.category],
          FREventParametr.address  : [NSObject bs_safeString:self.address],
   FREventParametr.partner_hosting : [NSObject bs_safeString:self.partner_hosting],
       FREventParametr.category_id : [NSObject bs_safeString:self.category_id],
FREventParametr.open_to_fb_friends : @(self.open_to_fb_friends),
     FREventParametr.thumbnail_url : [NSObject bs_safeString:self.thumbnail_url],
         FREventParametr.isFeature : @(self.isFeatured),
            };
}

@end

