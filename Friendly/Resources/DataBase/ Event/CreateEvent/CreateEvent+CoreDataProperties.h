//
//  CreateEvent+CoreDataProperties.h
//  Friendly
//
//  Created by Sergey on 02.08.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CreateEvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateEvent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSData *placeImage;
@property (nullable, nonatomic, retain) NSString *image_url;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *lon;
@property (nullable, nonatomic, retain) NSString *info;
@property (nullable, nonatomic, retain) NSNumber *lat;
@property (nullable, nonatomic, retain) NSString *category_id;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSNumber *age_min;
@property (nullable, nonatomic, retain) NSNumber *age_max;
@property (nullable, nonatomic, retain) NSNumber *slots;
@property (nullable, nonatomic, retain) NSString *date_;
@property (nullable, nonatomic, retain) NSString *time_;
@property (nullable, nonatomic, retain) NSString *event_start;
@property (nullable, nonatomic, retain) NSString *creator_id;
@property (nullable, nonatomic, retain) NSNumber *show_number;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSNumber *open_to_fb_friends;
@property (nullable, nonatomic, retain) NSString *locationName;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *partner_hosting;
@property (nullable, nonatomic, retain) NSString *thumbnail_url;
@property (nullable, nonatomic, retain) NSNumber *isUpdate;
@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) NSString *inviteUsersId;
@property (nullable, nonatomic, retain) NSString *requests;
@property (nullable, nonatomic, retain) NSNumber *isFeatured;

@end

NS_ASSUME_NONNULL_END
