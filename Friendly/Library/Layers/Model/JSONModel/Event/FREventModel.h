//
//  FREventModel.h
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRUserModel.h"


typedef NS_ENUM(NSInteger, FREventRequestStatusType) {
    FREventRequestStatusAvailableToJoin,
    FREventRequestStatusPending,
    FREventRequestStatusAccepted,
    FREventRequestStatusDeclined,
    FREventRequestStatusUnsubscribe,
    FREventRequestStatusDiscard,
};

typedef NS_ENUM(NSInteger, FREventType) {
    FREventTypeNew,
    FREventTypeFeatured,
    FREventTypePopular,
};




@interface FRPartnerUser : JSONModel

@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* id;

@end

@interface FRJoinUser : JSONModel

+ (instancetype)initWithPartner:(FRPartnerUser*)partner;

@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* first_name;

@end

@protocol FRPartnerUser <NSObject>

@end

@protocol FRJoinUser <NSObject>

@end

@interface FRRequestsUser : JSONModel

@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* birthday;
@property (nonatomic, strong) NSString<Optional>* request_message;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* way;
@property (nonatomic, strong) NSString<Optional>* request_id;

@end

@protocol FRRequestsUser <NSObject>
@end

@interface FREventModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* info;
@property (nonatomic, strong) NSString<Optional>* time_;
@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) NSString<Optional>* gender;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* lon;
@property (nonatomic, strong) NSString<Optional>* event_start;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* partner_hosting;
@property (nonatomic, strong) NSString<Optional>* date_;
@property (nonatomic, strong) NSString<Optional>* age_min;
@property (nonatomic, strong) NSString<Optional>* lat;
@property (nonatomic, strong) NSString<Optional>* age_max;
@property (nonatomic, strong) NSString<Optional>* slots;
@property (nonatomic, strong) NSString<Optional>* category;
@property (nonatomic, strong) NSString<Optional>* image_url;
@property (nonatomic, strong) NSString<Optional>* category_id;
@property (nonatomic, strong) NSString<Optional>* tag;
@property (nonatomic, strong) NSString<Optional>* partner_is_accepted;
@property (nonatomic, strong) NSString<Optional>* address;
@property (nonatomic, strong) NSString<Optional>* request_status;
@property (nonatomic, strong) NSString<Optional>* way;
@property (nonatomic, strong) NSArray<Optional, FRRequestsUser>* user_requests;
@property (nonatomic, strong) NSString<Optional>* event_type;
@property (nonatomic, strong) NSString<Optional>* joined_at;
@property (nonatomic, strong) FRUserModel<Optional>* creator;
@property (nonatomic, strong) FRPartnerUser<Optional>* partner;
@property (nonatomic, strong) NSString<Optional>* is_deleted;
@property (nonatomic, strong) NSString<Optional>* is_featured;
@property (nonatomic, strong) NSString<Optional>* is_popular;
@property (nonatomic, strong) NSString<Optional>* thumbnail_url;


@property (nonatomic, assign) BOOL open_to_fb_friends;
@property (nonatomic, assign) BOOL show_number;

@property (nonatomic, strong) NSString<Optional>* isJoining;
@property (nonatomic, strong) NSArray<Optional, FRJoinUser>* users;

@end

@protocol FREventModel <NSObject>

@end

@interface FRFriendEventsModel : JSONModel

@property (nonatomic, strong) NSArray<FREventModel, Optional>* events;

@end

@interface FREventModels : JSONModel

@property (nonatomic, strong) NSArray<FREventModel, Optional>* events;
@property (nonatomic, strong) NSArray<FREventModel, Optional>* top_events;
@property (nonatomic, strong) NSArray<Optional>* eventEntitys;

@end

@protocol FREventRelatedCategoryModel <NSObject>


@end

@interface FREventRelatedCategoryModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* count;
@property (nonatomic, strong) NSString<Optional>* category_id;

@end

@interface FREventSearchModels : JSONModel

@property (nonatomic, strong) FREventRelatedCategoryModel<Optional>* related_category;
@property (nonatomic, strong) NSArray<FREventModel, Optional>* events;
@property (nonatomic, strong) NSArray<FRUserModel, Optional>* discover_people;

@end

@interface FREventSearchEntityModels : JSONModel

@property (nonatomic, strong) FREventRelatedCategoryModel* related_category;
@property (nonatomic, strong) NSArray<FREvent*>* events;
@property (nonatomic, strong) NSArray* discover_people;

@end


@interface FREventAllDeleteModel : JSONModel

@property (nonatomic, strong) NSArray<NSString*>* event_ids;

@end

@interface FREventFeatureModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* create_featured_enable;
@property (nonatomic, strong) NSString<Optional>* created_featured_events;
@property (nonatomic, strong) NSString<Optional>* invited_from_fb;
@property (nonatomic, strong) FRUserModel<Optional>* invited_last;

@end

