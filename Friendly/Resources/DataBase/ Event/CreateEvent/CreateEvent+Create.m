//
//  CreateEvent+Create.m
//  Friendly
//
//  Created by Sergey on 02.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "CreateEvent+Create.h"

@implementation CreateEvent (Create)

+ (instancetype)createFromDomain:(FREventDomainModel*)domainModel inContext:(NSManagedObjectContext*)context {
    
    CreateEvent* event = [CreateEvent MR_createEntityInContext:context];
    event.isUpdate = @(false);
    if (domainModel.placeImage) {
        event.placeImage = UIImageJPEGRepresentation(domainModel.placeImage, 1);
    }
    
    event.image_url = domainModel.image_url;
    event.title = domainModel.title;
    event.lon = @(domainModel.lon);
    event.info = domainModel.info;
    event.lat = @(domainModel.lat);
    event.category_id = domainModel.category_id;
    event.gender = @(domainModel.gender);
    event.age_min = @(domainModel.age_min);
    event.age_max = @(domainModel.age_max);
    event.slots = @(domainModel.slots);
    event.date_ = domainModel.date_;
    event.time_ = domainModel.time_;
    event.event_start = domainModel.event_start;
    event.creator_id = domainModel.creator_id;
    event.show_number = @(domainModel.show_number);
    event.category = domainModel.category;
    event.open_to_fb_friends = @(domainModel.open_to_fb_friends);
    event.locationName = domainModel.locationName;
    event.address = domainModel.address;
    event.partner_hosting = domainModel.partner_hosting;
    event.thumbnail_url = domainModel.thumbnail_url;
    event.requests = domainModel.requests;
    event.isFeatured = @(domainModel.isFeatured);
    return event;
}

- (FREventDomainModel*)domainModel {
    
    FREventDomainModel* domainModel = [FREventDomainModel new];
    
    if (self.placeImage) {
        domainModel.placeImage = [UIImage imageWithData:self.placeImage];
    }
    
    domainModel.image_url = self.image_url;
    domainModel.title = self.title;
    domainModel.lon = self.lon.doubleValue;
    domainModel.info = self.info;
    domainModel.lat = self.lat.doubleValue;
    domainModel.category_id = self.category_id;
    domainModel.gender = self.gender.integerValue;
    domainModel.age_min = self.age_min.integerValue;
    domainModel.age_max = self.age_max.integerValue;
    domainModel.slots = self.slots.integerValue;
    domainModel.date_ = self.date_;
    domainModel.time_ = self.time_;
    domainModel.event_start = self.event_start;
    domainModel.creator_id = self.creator_id;
    domainModel.show_number = self.show_number.boolValue;
    domainModel.category = self.category;
    domainModel.open_to_fb_friends = self.open_to_fb_friends.boolValue;
    domainModel.locationName = self.locationName;
    domainModel.address = self.address;
    domainModel.partner_hosting = self.partner_hosting;
    domainModel.thumbnail_url = self.thumbnail_url;
    domainModel.isFeatured = self.isFeatured.boolValue;

    return domainModel;
}
@end
