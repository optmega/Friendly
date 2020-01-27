//
//  UserEntity+Create.m
//  Friendly
//
//  Created by Dmitry on 24.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "UserEntity+Create.h"
#import "FRDateManager.h"
#import "Interest.h"
#import "InstagramImage.h"
#import "MutualUser.h"
#import "Filter.h"

@implementation UserEntity (Create)

+ (instancetype)initWithUserModel:(FRUserModel*)userModel {
    return [self initWithUserModel:userModel inContext:[NSManagedObjectContext MR_defaultContext]];
}

+ (instancetype)initWithUserModel:(FRUserModel*)userModel inContext:(NSManagedObjectContext*)context
{
    if (!userModel.id) {
        UserEntity* welcomUser = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", @"WELCOM_TEMP_USER"] inContext:context];
        if (!welcomUser) {
             welcomUser = [UserEntity MR_createEntityInContext:context];
            welcomUser.user_id = @"WELCOM_TEMP_USER";
        }
        welcomUser.userPhoto = userModel.photo;
        welcomUser.firstName = userModel.first_name;
        return welcomUser;
    }
    
    UserEntity* model = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", userModel.id] inContext:context];
    if (!model) {
        model = [UserEntity MR_createEntityInContext:context];
    }

    [model update:userModel];

    CurrentUser* currentUser = [FRUserManager sharedInstance].currentUser;
//    if (![model.user_id isEqualToString:currentUser.user_id] && model.isFriend.boolValue) {
//        
//        UserEntity* temp = [[NSManagedObjectContext MR_defaultContext] objectWithID:model.objectID];
//        [currentUser addFriendsObject:temp];
//    }
    
    return model;
}

- (void)update:(FRUserModel*)userModel
{
    self.user_id = userModel.id;
    self.instagram_id = userModel.instagram_id;
    self.firstName = userModel.first_name;
    self.lastName = userModel.last_name;
    self.birthday = [FRDateManager dateFromBirthdayFormat:userModel.birthday];
    self.lastActive = [FRDateManager dateFromServerWithString:userModel.last_active];
    self.systemStatus = [NSNumber numberWithInteger: userModel.system_status.integerValue];
    self.userInfo = userModel.user_info;
    self.userPhoto = userModel.photo;
    self.wallPhoto = userModel.wall;
    self.createdAt = [FRDateManager dateFromServerWithString:userModel.created_at];
    self.userType = @(userModel.user_type.integerValue);
    self.apnsToken = userModel.apns_token;
    self.updateAt = [FRDateManager dateFromServerWithString:userModel.updated_at];
    self.userThumbnailPhoto = userModel.thumbnail;
    self.facebookId = userModel.facebook_id;
    self.email = userModel.email;
    self.jobTitle = userModel.job_title;
    self.yourBio = userModel.your_bio;
    self.whyAreYouHere = userModel.why_are_you_here;
    self.mobileNumber = userModel.mobile_number;
    self.availableStatus = @(userModel.availability_status.integerValue);
    if (userModel.friends_since) {
        
        self.friends_since = [FRDateManager dateFromServerWithString:userModel.friends_since];
    }
    self.way = @(userModel.way.doubleValue);
    
    [self removeInterests:self.interests];
    self.interests = nil;
    for (FRInterestsModel* intModel in userModel.interests) {
        Interest* interest = [Interest initWithModel:intModel inContext:self.managedObjectContext];
        [self addInterestsObject:interest];
    }
    
    self.filter = [Filter initFilterWith:userModel.filter inContext:self.managedObjectContext];
    self.isFriend = @(userModel.is_friend.integerValue);
    self.privateAccount = @(userModel.private_account.integerValue);
    self.instagramMediaCount = userModel.instagram_media_count;
    self.instagramUsername = userModel.instagram_username;
    

    self.images = nil;
    for (NSString* url in userModel.instagram_images) {
        InstagramImage* image = [InstagramImage initWithModel:url inContext:self.managedObjectContext];
        [self addImagesObject:image];
    }
    
    self.mutualFriend = nil;
    for (FRMutualFriend* mutual in userModel.mutual_friends) {
        MutualUser* user = [MutualUser initWithModel:mutual inContext:self.managedObjectContext];
        [self addMutualFriendObject:user];
    }
    
    self.coverImage = userModel.cover_image;
}


@end

