//
//  FREventDomainModel.h
//  Friendly
//
//  Created by Sergey Borichev on 11.03.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//


#import "FRBaseDomainModel.h"

@interface FREventDomainModel : FRBaseDomainModel

@property (nonatomic, strong) UIImage* placeImage;

@property (nonatomic, strong) NSString* image_url;
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSString* info;
@property (nonatomic, assign) CGFloat lon;
@property (nonatomic, assign) CGFloat lat;
@property (nonatomic, strong) NSString* category_id;
@property (nonatomic, assign) FRGenderType gender;
@property (nonatomic, assign) NSInteger age_min;
@property (nonatomic, assign) NSInteger age_max;
@property (nonatomic, assign) NSInteger slots;
@property (nonatomic, strong) NSString* date_;
@property (nonatomic, strong) NSString* time_;
@property (nonatomic, strong) NSString* event_start;
@property (nonatomic, strong) NSString* creator_id;
@property (nonatomic, assign) BOOL show_number;
@property (nonatomic, strong) NSString* category;

@property (nonatomic, assign) BOOL open_to_fb_friends;
@property (nonatomic, strong) NSString* locationName;

@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* partner_hosting;
@property (nonatomic, strong) NSString* thumbnail_url;
@property (nonatomic, strong) NSString* requests;
@property (nonatomic, assign) BOOL isFeatured;

@end
