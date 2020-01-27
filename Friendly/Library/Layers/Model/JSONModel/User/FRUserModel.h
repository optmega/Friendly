//
//  FRUserModel.h
//  Friendly
//
//  Created by Sergey Borichev on 02.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRInterestsModel.h"


typedef NS_ENUM(NSInteger, FRFilterDateType) {
    FRFilterDateAnytime,
    FRFilterDateThisWeekend,
    FRFilterDateThisWeek
};



@interface FRFilterModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* distance;
@property (nonatomic, strong) NSString<Optional>* age_min;
@property (nonatomic, strong) NSString<Optional>* age_max;
@property (nonatomic, strong) NSString<Optional>* gender;
@property (nonatomic, strong) NSString<Optional>* date;
@property (nonatomic, strong) NSString<Optional>* lat;
@property (nonatomic, strong) NSString<Optional>* lon;
@property (nonatomic, strong) NSString<Optional>* place_name;
@property (nonatomic, strong) NSString<Optional>* sort_by_date;

@end

@protocol FRFilterModel <NSObject>
@end

@protocol FRUserModel <NSObject>
@end

@protocol NSString <NSObject>

@end

@interface FRMutualFriend : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* thumbnail;

@end

@protocol FRMutualFriend <NSObject>
@end
@interface FRUserModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* instagram_id;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* last_name;
@property (nonatomic, strong) NSString<Optional>* birthday;
@property (nonatomic, strong) NSString<Optional>* last_active;
@property (nonatomic, strong) NSString<Optional>* system_status;
@property (nonatomic, strong) NSString<Optional>* user_info;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* wall;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) FRFilterModel<Optional>* filter;
@property (nonatomic, strong) NSString<Optional>* user_type;
@property (nonatomic, strong) NSString<Optional>* apns_token;
@property (nonatomic, strong) NSString<Optional>* updated_at;
@property (nonatomic, strong) NSString<Optional>* thumbnail;
@property (nonatomic, strong) NSString<Optional>* facebook_id;
@property (nonatomic, strong) NSString<Optional>* email;
@property (nonatomic, strong) NSString<Optional>* job_title;
@property (nonatomic, strong) NSString<Optional>* your_bio;
@property (nonatomic, strong) NSString<Optional>* why_are_you_here;
@property (nonatomic, strong) NSString<Optional>* mobile_number;
@property (nonatomic, strong) NSString<Optional>* availability_status;
@property (nonatomic, strong) NSArray<Optional, FRInterestsModel>* interests;
@property (nonatomic, strong) NSString<Optional>* is_friend;
@property (nonatomic, strong) NSString<Optional>* private_account;
@property (nonatomic, strong) NSString<Optional>* instagram_media_count;
@property (nonatomic, strong) NSString<Optional>* instagram_username;
@property (nonatomic, strong) NSArray<Optional>* instagram_images;
@property (nonatomic, strong) NSArray<Optional, FRMutualFriend>* mutual_friends;
@property (nonatomic, strong) NSString<Optional>* cover_image;
@property (nonatomic, strong) NSString<Optional>* friends_since;
@property (nonatomic, strong) NSString<Optional>* event_requests;
@property (nonatomic, strong) NSString<Optional>* filter_date;
@property (nonatomic, strong) NSString<Optional>* filter_lat;
@property (nonatomic, strong) NSString<Optional>* filter_lon;
@property (nonatomic, strong) NSString<Optional>* filter_place_name;
@property (nonatomic, strong) NSString<Optional>* filter_sort_by_date;
@property (nonatomic, strong) NSString<Optional>* gender;
@property (nonatomic, strong) NSString<Optional>* group_chat_messages;
@property (nonatomic, strong) NSString<Optional>* is_suspended;
@property (nonatomic, strong) NSString<Optional>* notification_steps;
@property (nonatomic, strong) NSString<Optional>* notified_about_me;
@property (nonatomic, strong) NSString<Optional>* first_login;
@property (nonatomic, strong) NSString<Optional>* way;
@end

