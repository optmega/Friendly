//
//  FREvent+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 01.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "FREvent.h"

NS_ASSUME_NONNULL_BEGIN

@interface FREvent (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *isFeatured;
@property (nullable, nonatomic, retain) NSString *info;
@property (nullable, nonatomic, retain) NSDate *time_;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSNumber *lon;
@property (nullable, nonatomic, retain) NSDate *event_start;
@property (nullable, nonatomic, retain) NSString *creator_id;
@property (nullable, nonatomic, retain) NSString *partnerHosting;
@property (nullable, nonatomic, retain) NSDate *date_;
@property (nullable, nonatomic, retain) NSNumber *ageMin;
@property (nullable, nonatomic, retain) NSNumber *lat;
@property (nullable, nonatomic, retain) NSNumber *ageMax;
@property (nullable, nonatomic, retain) NSNumber *slots;
@property (nullable, nonatomic, retain) NSString *category;
@property (nullable, nonatomic, retain) NSString *imageUrl;
@property (nullable, nonatomic, retain) NSString *categoryId;
@property (nullable, nonatomic, retain) NSString *tag;
@property (nullable, nonatomic, retain) NSNumber *partnerIsAccepted;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSNumber *requestStatus;
@property (nullable, nonatomic, retain) NSNumber *way;
@property (nullable, nonatomic, retain) NSNumber *eventType;
@property (nullable, nonatomic, retain) NSDate *joinedAt;
@property (nullable, nonatomic, retain) NSNumber *openToFBFriends;
@property (nullable, nonatomic, retain) NSNumber *showNumber;
@property (nullable, nonatomic, retain) NSNumber *isJoining;
@property (nullable, nonatomic, retain) NSString *eventId;
@property (nullable, nonatomic, retain) NSString *thumbnail_url;
@property (nullable, nonatomic, retain) NSNumber *isDelete;
@property (nullable, nonatomic, retain) NSNumber *isPopular;
@property (nullable, nonatomic, retain) NSNumber *categoryType;
@property (nullable, nonatomic, retain) UserEntity *creator;
@property (nullable, nonatomic, retain) NSSet<MemberUser *> *memberUsers;
@property (nullable, nonatomic, retain) MemberUser *partnerUser;
@property (nullable, nonatomic, retain) NSSet<UserRequest *>* userRequest;
@property (nullable, nonatomic, retain) FRGroupRoom* groupRoom;

@end

@interface FREvent (CoreDataGeneratedAccessors)

- (void)addUserRequest:(NSSet<UserRequest *> *)objects;
- (void)removeUserRequest:(NSSet<UserRequest *> *)objects;
- (void)addUserRequestObject:(UserRequest *)object;
- (void)removeUserRequestObject:(UserRequest *)object;


- (void)addMemberUsersObject:(MemberUser *)value;
- (void)removeMemberUsersObject:(MemberUser *)value;
- (void)addMemberUsers:(NSSet<MemberUser *> *)values;
- (void)removeMemberUsers:(NSSet<MemberUser *> *)values;

@end

NS_ASSUME_NONNULL_END
