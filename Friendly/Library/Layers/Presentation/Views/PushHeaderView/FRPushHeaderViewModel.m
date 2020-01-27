//
//  FRPushHeaderViewModel.m
//  Friendly
//
//  Created by Dmitry on 20.06.16.
//  Copyright © 2016 TecSynt. All rights reserved.
//

#import "FRPushHeaderViewModel.h"
#import "UIImageView+WebCache.h"
#import "FRStyleKit.h"
#import "UIImageHelper.h"
#import "FRUserModel.h"
#import "FRSettingsTransport.h"
#import "UserEntity.h"
#import "FRPushModel.h"

@interface FRPushHeaderViewModel ()

@property (nonatomic, strong) FRPushModel* pushData;

@end

@implementation FRPushHeaderViewModel

+ (instancetype)initWithPushData:(FRPushModel*)pushData
{
    FRPushHeaderViewModel* model = [FRPushHeaderViewModel new];
    model.pushData = pushData;
    
    return model;
}

- (void)setLeftIconImage:(UIImageView*)imageView
{
    imageView.image = [FRUserManager sharedInstance].logoImage;
    
    if (self.pushData)
    {
        switch (self.pushData.notification_type.integerValue) {
                
            case FRPushNotificationTypeSomeoneAddsYou:
            {
            } break;
            case FRPushNotificationTypeSomeoneAsksToJoinYourEvent:
            {
            } break;
            case FRPushNotificationTypeSomeoneInvitesYouToAnEvent:
            {
            } break;
            case FRPushNotificationTypeNewMessage:
            {
                [self _updateUserPhoto:imageView];
            } break;
            case FRPushNotificationTypeEventReminder:
            {
            } break;
            case FacebookFriendInvitedByYouJoined:
            {
                 [self _updateUserPhoto:imageView];
            } break;
                
            default:
                break;
        }
    }
    
}



- (BOOL)canShowAlert
{
    if (self.pushData)
    {
        switch (self.pushData.notification_type.integerValue) {
                
            case FRPushNotificationTypeSomeoneAddsYou:
            {
                return true;
            } break;
            case FRPushNotificationTypeSomeoneAsksToJoinYourEvent:
            {
                return true;
            } break;
            case FRPushNotificationTypeSomeoneInvitesYouToAnEvent:
            {
                return true;
            } break;
            case FRPushNotificationTypeNewMessage:
            {
                return true;
            } break;
            case FRPushNotificationTypeEventReminder:
            {
                return true;
            } break;
            case FRPushNotificationTypeNewUser:
            {
                return true;
            } break;
            case FRPushNotificationTypeSomeoneInvitesYouToAnEventAsCohost:
            {
                return true;
            } break;
            case FacebookFriendInvitedByYouJoined: {
                return true;
            } break;
                
            default:
                break;
        }

    }
    return false;
}

- (NSString*)title
{
    if (self.pushData)
    {
        switch (self.pushData.notification_type.integerValue) {
                
            case FRPushNotificationTypeSomeoneAddsYou:
            {
                _title = FRLocalizedString(@"Someone adds you", nil);
            } break;
            case FRPushNotificationTypeSomeoneAsksToJoinYourEvent:
            {
                _title = FRLocalizedString(@"Someone asks to Join your event", nil);
            } break;
            case FRPushNotificationTypeSomeoneInvitesYouToAnEvent:
            {
                _title = FRLocalizedString(@"New event", nil);
            } break;
            case FRPushNotificationTypeNewMessage:
            {
                _title = FRLocalizedString(@"New message", nil);
            } break;
            case FRPushNotificationTypeEventReminder:
            {
                _title = FRLocalizedString(@"Reminder", nil);
            } break;
            case FRPushNotificationTypeNewUser:
            {
                _title = FRLocalizedString(@"New user", nil);
            } break;
            case FRPushNotificationTypeSomeoneInvitesYouToAnEventAsCohost:
            {
                _title = FRLocalizedString(@"Someone invites you to an event as cohost", nil);
            } break;
            case FacebookFriendInvitedByYouJoined: {
                _title = FRLocalizedString(@"New friedn", nil);
            } break;

                
                
            default:
                break;
        }
    }
    
    return _title;
}

- (NSString*)subtitle
{
    if (self.pushData)
    {
        
        _subtitle = self.pushData.aps.alert;
    }
    
    return _subtitle;
}

- (void)setRightIconImage:(UIImageView*)imageView
{
    UIImage* image = nil;
    switch (self.pushData.notification_type.integerValue) {
        
        case FRPushNotificationTypeSomeoneAddsYou:
        {
            
        } break;
        case FRPushNotificationTypeSomeoneAsksToJoinYourEvent:
        {
            
        } break;
        case FRPushNotificationTypeSomeoneInvitesYouToAnEvent:
        {
            
        } break;
        case FRPushNotificationTypeNewMessage:
        {
            image = [FRStyleKit imageOfTabMessagesCanvas];
        } break;
        case FRPushNotificationTypeEventReminder:
        {
            
        } break;
        case FRPushNotificationTypeNewUser:
        {

        } break;
        case FRPushNotificationTypeSomeoneInvitesYouToAnEventAsCohost:
        {

        } break;
            
        default:
            break;
    }
    
    imageView.image = [UIImageHelper image:image color:[UIColor whiteColor]];
    
//    NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:self.rightIconUrl]];
//    [imageView sd_setImageWithURL:url completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        imageView.image = image;
//    }];
}

- (void)_updateUserPhoto:(UIImageView*)imageView
{
    if (self.pushData.user_id && self.pushData.user_id.length != 0 && ![self.pushData.user_id isEqualToString:[FRUserManager sharedInstance].userId]) {
        
        NSManagedObjectContext* context = [NSManagedObjectContext MR_defaultContext];
        UserEntity* user = [UserEntity MR_findFirstWithPredicate:[NSPredicate predicateWithFormat:@"user_id == %@", self.pushData.user_id ?: @"0"] inContext:context];
        
        NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:user.userPhoto]];
        [imageView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
        
        if (user == nil) {
            
            [FRSettingsTransport profileFofUserId:self.pushData.user_id success:^(UserEntity *userProfile, NSArray *mutualFriends) {
                
                NSURL* url = [NSURL URLWithString:[NSObject bs_safeString:userProfile.userPhoto]];
                [imageView sd_setImageWithURL:url placeholderImage:[FRStyleKit imageOfDefaultAvatar]];
                
            } failure:^(NSError *error) {
                
            }];
        }
    } else {
        imageView.image = [UIImage imageNamed:@"Intro-message"];
    }

}
@end
