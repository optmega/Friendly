//
//  FRFriendsListModel.h
//  Friendly
//
//  Created by Sergey Borichev on 07.04.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "FRUserModel.h"


typedef NS_ENUM(NSInteger, FRFriendsRequestStatusType) {
    FRFriendsRequestStatusWaitingForApprove,
    FRFriendsRequestStatusAccepted,
    FRFriendsRequestStatusDeclined
};


@interface FRFriendsListModel : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRUserModel>* friends;

@end

@interface FRCandidatesListModel : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRUserModel>* friends;

@end

@interface FRFriendlyRequestModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* request_message;
@property (nonatomic, strong) NSString<Optional>* friend_id;
@property (nonatomic, strong) NSString<Optional>* created_at;
@property (nonatomic, strong) NSString<Optional>* initiator_id;
@property (nonatomic, strong) NSString<Optional>* request_status;
//@property (nonatomic, strong) NSString<Optional>* way;
@property (nonatomic, strong) NSString<Optional>* id;

@property (nonatomic, strong) FRUserModel <Optional>* friend;

@end

@protocol FRFriendlyRequestModel <NSObject>
@end


@interface FRPotentialFriendModel : JSONModel

@property (nonatomic, strong) NSString<Optional>* first_name;
@property (nonatomic, strong) NSString<Optional>* last_name;
@property (nonatomic, strong) NSString<Optional>* photo;
@property (nonatomic, assign) NSInteger mutuals_count;
@property (nonatomic, strong) NSString<Optional>* birthday;
@property (nonatomic, strong) NSString<Optional>* thumbnail;
@property (nonatomic, strong) NSString<Optional>* user_id;

@end


@protocol FRPotentialFriendModel <NSObject>
@end


@interface FRFriendlyRequestsModel : JSONModel

@property (nonatomic, strong) NSArray<Optional, FRFriendlyRequestModel>* friendly_requests;
@property (nonatomic, strong) NSArray<Optional, FRPotentialFriendModel>* people_you_may_know;

@end


