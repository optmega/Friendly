//
//  FRMyProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 17.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRMyProfileDataSource.h"
#import "BSMemoryStorage.h"
#import "FRMyProfileUserPhotoCellViewModel.h"
#import "FRMyProfileIconCellViewModel.h"
#import "FRStyleKit.h"
#import "FRProfileShareInstagramCellViewModel.h"
#import "FRMyProfileUserBioCellViewModel.h"
#import "FRMyProfileWhyAreYouCellViewModel.h"
#import "FRUserModel.h"
#import "FRMyProfileViewConstants.h"
#import "FRMyProfileInterestsCellViewModel.h"
#import "FRInterestsModel.h"
#import "FRPhotosMutualFriendCellViewModel.h"
#import "FRUserManager.h"

@interface FRMyProfileDataSource ()
<
    FRMyProfileUserPhotoCellViewModelDelegate, FRProfileShareInstagramCellViewModelDelegate, FRPhotosMutualFriendCellViewModelDelegate, FRMyProfileIconCellViewModelDelegate
>

@end

@implementation FRMyProfileDataSource

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        self.storage = [BSMemoryStorage storage];
    }
    return self;
}

- (void)setupStorage
{
    
    FRMyProfileUserPhotoCellViewModel* userPhotoModel = [FRMyProfileUserPhotoCellViewModel initWithModel:nil];
    userPhotoModel.delegate = self;
    [self.storage addItem:userPhotoModel];
   
    
    FRMyProfileIconCellViewModel* availableForMeetUpModel = [FRMyProfileIconCellViewModel new];
    availableForMeetUpModel.isOpen = [FRUserManager sharedInstance].available_for_meet;
    availableForMeetUpModel.title = FRLocalizedString(@"Available for a meetup?", nil);
    availableForMeetUpModel.subtitle = FRLocalizedString(@"Turn on to let your friends know you free", nil);

    availableForMeetUpModel.icon = [FRStyleKit imageOfCombinedShapeCanvas2];
    [self.storage addItem:availableForMeetUpModel];
    
    FRMyProfileIconCellViewModel* inviteYourFriendsModel = [FRMyProfileIconCellViewModel new];
    inviteYourFriendsModel.title = FRLocalizedString(@"Invite your friends", nil);
    inviteYourFriendsModel.subtitle = FRLocalizedString(@"and share instant access between your events", nil);
    inviteYourFriendsModel.icon = [FRStyleKit imageOfCombinedShapeCanvas3];
    inviteYourFriendsModel.delegate = self;
    [self.storage addItem:inviteYourFriendsModel];

    
    FRMyProfileIconCellViewModel* numberModel = [FRMyProfileIconCellViewModel new];
    numberModel.title = FRLocalizedString(@"Mobile (hidden)", nil);
    numberModel.subtitle = FRLocalizedString(@"Only provided to approved guests in your event", nil);
    numberModel.icon = [FRStyleKit imageOfCombinedShapeCanvas4];
    numberModel.delegate = self;
    [self.storage addItem:numberModel];
 
    
    FRMyProfileUserBioCellViewModel* userBio = [FRMyProfileUserBioCellViewModel new];
    userBio.content = @"";
    [self.storage addItem:userBio];
    
    
    FRMyProfileWhyAreYouCellViewModel* whyAreYouCell = [FRMyProfileWhyAreYouCellViewModel new];
    whyAreYouCell.title = FRLocalizedString(@"Why are you here?", nil);
    whyAreYouCell.subtitle = @"";
    [self.storage addItem:whyAreYouCell];
    
    FRProfileShareInstagramCellViewModel* sharedInstagramModel = [FRProfileShareInstagramCellViewModel new];
    sharedInstagramModel.title = FRLocalizedString(@"Share instagram photos", nil);
    sharedInstagramModel.subtitle = FRLocalizedString(@"Profile with images perform better", nil);
    sharedInstagramModel.delegate = self;
    [self.storage addItem:sharedInstagramModel];
    
    FRPhotosMutualFriendCellViewModel* friendsModel = [FRPhotosMutualFriendCellViewModel new];
    friendsModel.isMyProfileCell = YES;
    friendsModel.isMyProfile = true;
    friendsModel.friendsTitle = @"0 friends";
    friendsModel.delegate = self;
    [self.storage addItem:friendsModel];

    FRMyProfileInterestsCellViewModel* interestsModel = [FRMyProfileInterestsCellViewModel new];
    interestsModel.title = FRLocalizedString(@"Interests", nil);
    interestsModel.tags = @[];
    [self.storage addItem:interestsModel];
    
}



- (void)updateStorage:(CurrentUser*)model andUsers:(NSArray *)users
{
    [self.storage beginUpdate];
    
    [self.delegate updateWallImage:[model wallPhoto] ?: [model coverImage]];
    
    FRMyProfileUserPhotoCellViewModel* userPhotoModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeUserPhoto inSection:0]];
    [userPhotoModel updateWithModel:model];
    userPhotoModel.delegate = self;
    userPhotoModel.statusString = @"AVAILABLE FOR A MEET";

    
    FRMyProfileIconCellViewModel* availableForMeetUpModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMYProfileCellTypeAvailable inSection:0]];
//    availableForMeetUpModel.isOpen = model.available_for_meet;
        availableForMeetUpModel.isOpen = [FRUserManager sharedInstance].available_for_meet;
    availableForMeetUpModel.delegate = self;
    [self.storage reloadItem:availableForMeetUpModel];
    
    
    FRMyProfileUserBioCellViewModel* userBio = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeYourBio inSection:0]];
    userBio.content = model.yourBio;
    [self.storage reloadItem:userBio];
    
    FRMyProfileWhyAreYouCellViewModel* whyAreYouCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeWhyAreYouHere inSection:0]];
    whyAreYouCell.subtitle = model.whyAreYouHere;
    [self.storage reloadItem:whyAreYouCell];
    
    FRProfileShareInstagramCellViewModel* sharedInstagramModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeShareInstagram inSection:0]];
    sharedInstagramModel.title = FRLocalizedString(@"Share instagram photos", nil);
    sharedInstagramModel.subtitle = FRLocalizedString(@"Profile with images preform better", nil);
    sharedInstagramModel.photos = model.images.allObjects;
    sharedInstagramModel.instagram_media_count = model.instagramMediaCount;
    sharedInstagramModel.instagram_username = model.instagramUsername;
    
    [self.storage reloadItem:sharedInstagramModel];
    
    FRPhotosMutualFriendCellViewModel* friendsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeFriends inSection:0]];
    
//    if (model.friends.allObjects.count) {
    
     NSInteger userscount = [[FRUserManager sharedInstance].currentUser.allFriendsCount integerValue];
    
        friendsModel.friendsTitle = [NSString stringWithFormat:@"%lu friends", (unsigned long)userscount];
        friendsModel.users = [users sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];;
//        [self.storage reloadItem:friendsModel];
//    }
//    else
//    {
//        [self.storage removeItem:friendsModel];
//    }
    


    FRMyProfileInterestsCellViewModel* interestsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeInterests inSection:0]];
    
    interestsModel.tags = [[model.interests allObjects] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:true]]];
    interestsModel.title = [NSString stringWithFormat:@"%lu Interests", (unsigned long)model.interests.count];
    [self.storage reloadItem:interestsModel];
    
    [self.storage endUpdate];
}

- (void)updateUserStatusStatus:(NSString*)status
{
    FRMyProfileUserPhotoCellViewModel* userPhotoModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRMyProfileCellTypeUserPhoto inSection:0]];

    userPhotoModel.statusString = status;
    [self.storage reloadItem:userPhotoModel];

}


#pragma mark - Private


#pragma mark - FRMyProfileUserPhotoCellViewModelDelegate

- (void)saveSelected
{
    [self.delegate saveEditSelected];
}

- (void)settingSelected
{
    [self.delegate settingSelected];
}

- (void)statusSelected
{
    [self.delegate statusSelected];
}

- (void)connectSelected
{
    [self.delegate connectInstagramSelected];
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.delegate showPreviewWithImage:image];
}

- (void)showUserProfile:(NSString*)userId;
{
    [self.delegate showUserProfile:userId];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    [self.delegate showUserProfileWithEntity:user];
}

#pragma mark - FRMyProfileIconCellViewModelDelegate

- (void)changeStatus:(NSInteger)status {
    [self.delegate changeStatus:status];
}

- (void)presentAddMobileController
{
    [self.delegate presentAddMobileController];
}

- (void)presentInviteFriendsController
{
    [self.delegate presentInviteFriendsController];
}

@end
