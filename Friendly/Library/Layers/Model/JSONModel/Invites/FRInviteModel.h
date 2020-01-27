//
//  FRInviteModel.h
//  Friendly
//
//  Created by Zaslavskaya Yevheniya on 12.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FREventModel.h"

@interface FRInviteCreator : JSONModel

@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* user_id;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, strong) NSString<Optional>* birthday;
@property (nonatomic, strong) NSString<Optional>* way;
@property (nonatomic, strong) NSString<Optional>* is_fb_friend;
@property (nonatomic, strong) NSString<Optional>* friends_since;
@end


@interface FRInviteModel : JSONModel

@property (nonatomic, assign) BOOL event_is_full;
@property (nonatomic, strong) NSString<Optional>* request_message;
@property (nonatomic, strong) FRInviteCreator<Optional>* creator;
@property (nonatomic, strong) FREventModel<Optional>* event;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* id;
@property (nonatomic, strong) NSString<Optional>* is_invited_from_fb;

@end

@interface FRInviteToPartnerModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* title;
@property (nonatomic, strong) FRInviteCreator<Optional>* creator;
@property (nonatomic, strong) FREventModel<Optional>* event;
@property (nonatomic, strong) NSString<Optional>* creator_id;
@property (nonatomic, strong) NSString<Optional>* event_start;
@property (nonatomic, strong) NSString<Optional>* id;

@end


@protocol FRInviteModel <NSObject>

@end

@protocol FRInviteToPartnerModel <NSObject>


@end

@interface FRInviteModels : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRInviteModel>* invites;
@property (nonatomic, strong) NSArray<Optional, FRInviteToPartnerModel>* invites_to_partner;

@end