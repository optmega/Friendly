//
//  UserEntity+CoreDataProperties.h
//  Friendly
//
//  Created by Dmitry on 25.07.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//


@class FRPrivateRoom, CurrentUser;

#import "UserEntity.h"
#import "Filter.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *apnsToken;
@property (nullable, nonatomic, retain) NSNumber *availableStatus;
@property (nullable, nonatomic, retain) NSDate *birthday;
@property (nullable, nonatomic, retain) NSString *coverImage;
@property (nullable, nonatomic, retain) NSDate *createdAt;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *eventIntites;
@property (nullable, nonatomic, retain) NSNumber *eventRequests;
@property (nullable, nonatomic, retain) NSString *facebookId;
@property (nullable, nonatomic, retain) NSNumber *filterLat;
@property (nullable, nonatomic, retain) NSNumber *filterLon;
@property (nullable, nonatomic, retain) NSString *filterPlaceName;
@property (nullable, nonatomic, retain) NSDate *filterSortByDate;
@property (nullable, nonatomic, retain) NSDate *firlterDate;
@property (nullable, nonatomic, retain) NSString *firstName;
@property (nullable, nonatomic, retain) NSNumber *friendRequests;
@property (nullable, nonatomic, retain) NSDate *friends_since;
@property (nullable, nonatomic, retain) NSNumber *gender;
@property (nullable, nonatomic, retain) NSNumber *groupChatMessage;
@property (nullable, nonatomic, retain) NSString *instagram_id;
@property (nullable, nonatomic, retain) NSString *instagramMediaCount;
@property (nullable, nonatomic, retain) NSString *instagramUsername;
@property (nullable, nonatomic, retain) NSNumber *isFriend;
@property (nullable, nonatomic, retain) NSNumber *isSuspended;
@property (nullable, nonatomic, retain) NSString *jobTitle;
@property (nullable, nonatomic, retain) NSDate *lastActive;
@property (nullable, nonatomic, retain) NSString *lastName;
@property (nullable, nonatomic, retain) NSString *mobileNumber;
@property (nullable, nonatomic, retain) NSNumber *notificationSteps;
@property (nullable, nonatomic, retain) NSNumber *notifiedAboutMe;
@property (nullable, nonatomic, retain) NSNumber *privateAccount;
@property (nullable, nonatomic, retain) NSNumber *systemStatus;
@property (nullable, nonatomic, retain) NSDate *updateAt;
@property (nullable, nonatomic, retain) NSString *user_id;
@property (nullable, nonatomic, retain) NSString *userInfo;
@property (nullable, nonatomic, retain) NSString *userPhoto;
@property (nullable, nonatomic, retain) NSString *userThumbnailPhoto;
@property (nullable, nonatomic, retain) NSNumber *userType;
@property (nullable, nonatomic, retain) NSString *wallPhoto;
@property (nullable, nonatomic, retain) NSString *whyAreYouHere;
@property (nullable, nonatomic, retain) NSString *yourBio;
@property (nullable, nonatomic, retain) NSSet<InstagramImage *> *images;
@property (nullable, nonatomic, retain) NSSet<Interest *> *interests;
@property (nullable, nonatomic, retain) NSSet<MutualUser *> *mutualFriend;
@property (nullable, nonatomic, retain) Filter *filter;
@property (nullable, nonatomic, retain) NSSet<FRPrivateRoom *> *privateRooms;
@property (nullable, nonatomic, retain) NSNumber* way;
@property (nullable, nonatomic, retain) CurrentUser* currentUser;

@end

@interface UserEntity (CoreDataGeneratedAccessors)

- (void)addPrivateRoomsgesObject:(FRPrivateRoom *)value;
- (void)removePrivateRoomsObject:(FRPrivateRoom *)value;
- (void)addPrivateRooms:(NSSet<FRPrivateRoom *> *)values;
- (void)removePrivateRooms:(NSSet<FRPrivateRoom *> *)values;


- (void)addImagesObject:(InstagramImage *)value;
- (void)removeImagesObject:(InstagramImage *)value;
- (void)addImages:(NSSet<InstagramImage *> *)values;
- (void)removeImages:(NSSet<InstagramImage *> *)values;

- (void)addInterestsObject:(Interest *)value;
- (void)removeInterestsObject:(Interest *)value;
- (void)addInterests:(NSSet<Interest *> *)values;
- (void)removeInterests:(NSSet<Interest *> *)values;

- (void)addMutualFriendObject:(MutualUser *)value;
- (void)removeMutualFriendObject:(MutualUser *)value;
- (void)addMutualFriend:(NSSet<MutualUser *> *)values;
- (void)removeMutualFriend:(NSSet<MutualUser *> *)values;

@end

NS_ASSUME_NONNULL_END
