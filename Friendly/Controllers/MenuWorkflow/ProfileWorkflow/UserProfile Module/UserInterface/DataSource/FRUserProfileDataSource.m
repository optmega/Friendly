//
//  FRUserProfileInteractor.h
//  Friendly
//
//  Created by Sergey Borichev on 28.03.2016.
//  Copyright (c) 2016 TecSynt. All rights reserved.
//

#import "FRUserProfileDataSource.h"
#import "BSMemoryStorage.h"
#import "FRUserProfileHeaderCellViewModel.h"
#import "FRUserProfileViewConstants.h"
#import "FRUserProfileInstagramPhotosCellViewModel.h"
#import "FRMyProfileUserBioCellViewModel.h"
#import "FRMyProfileWhyAreYouCellViewModel.h"
#import "FRUserModel.h"
#import "FRMyProfileInterestsCellViewModel.h"
#import "FRPhotosMutualFriendCellViewModel.h"
#import "Interest.h"

@interface FRUserProfileDataSource () <FRUserProfileHeaderCellViewModelDelegate, FRUserProfileInstagramPhotosCellViewModelDelegate, FRPhotosMutualFriendCellViewModelDelegate>

@end

@implementation FRUserProfileDataSource

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
    FRUserProfileHeaderCellViewModel* headerModel = [FRUserProfileHeaderCellViewModel initWithModel:nil];
    headerModel.delegate = self;
    [self.storage addItem:headerModel];
    
    FRUserProfileInstagramPhotosCellViewModel* instagramModel = [FRUserProfileInstagramPhotosCellViewModel new];
    [self.storage addItem:instagramModel];
    
    FRMyProfileUserBioCellViewModel* bioModel = [FRMyProfileUserBioCellViewModel new];
    [self.storage addItem:bioModel];
    
    FRMyProfileWhyAreYouCellViewModel* whyAreYouCell = [FRMyProfileWhyAreYouCellViewModel new];
    whyAreYouCell.title = FRLocalizedString(@"Why are you here?", nil);
    whyAreYouCell.subtitle = @"";
    [self.storage addItem:whyAreYouCell];
    
    FRMyProfileInterestsCellViewModel* interestsModel = [FRMyProfileInterestsCellViewModel new];
    interestsModel.title = FRLocalizedString(@"Interests", nil);
    [self.storage addItem:interestsModel];
    
    FRPhotosMutualFriendCellViewModel* mutualModel = [FRPhotosMutualFriendCellViewModel new];
    mutualModel.isMyProfileCell = NO;
    mutualModel.delegate = self;
    [self.storage addItem:mutualModel];
    
}

- (void)updateStorageWithUserModel:(UserEntity*)userTemp withMutual:(NSArray*)mutual  isPrivateAccount:(BOOL)isPrivateAccount
{
    
    [UIView setAnimationsEnabled:false];
    
    
    UserEntity* user = [[NSManagedObjectContext MR_defaultContext] objectWithID:userTemp.objectID];
    
    [self.delegate updateWallImage:[user wallPhoto] ?: [user coverImage]];
    
    FRUserProfileHeaderCellViewModel* headerModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeHeader inSection:0]];
    headerModel.isPrivateAccount = isPrivateAccount;
    [headerModel updateWithModel:user];
    [self.storage reloadItem:headerModel];
    
    
    FRUserProfileInstagramPhotosCellViewModel* instagramModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeInstagramPhotos inSection:0]];
    instagramModel.delegate = self;
    instagramModel.photos = [user.images.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"url" ascending:true]]];
    instagramModel.instagram_media_count = user.instagramMediaCount;
    instagramModel.instagram_username = user.instagramUsername;
    instagramModel.userID = user.user_id;
    
    instagramModel.isPrivateMode =  [[[FRUserManager sharedInstance] currentUser] instagram_id] == nil || isPrivateAccount || [[FRUserManager sharedInstance].currentUser instagramUsername] == nil;
    
    [self.storage reloadItem:instagramModel];
    
    FRMyProfileUserBioCellViewModel* bioModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeBioUser inSection:0]];
    bioModel.content = user.yourBio;
    [self.storage reloadItem:bioModel];

    FRMyProfileWhyAreYouCellViewModel* whyAreYouCell = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeWhyAreYouHere inSection:0]];
    whyAreYouCell.subtitle = user.whyAreYouHere;
    [self.storage reloadItem:whyAreYouCell];
    
    FRMyProfileInterestsCellViewModel* interestsModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeInterests inSection:0]];
    
    interestsModel.tags = [user.interests allObjects];
    interestsModel.title = [NSString stringWithFormat:@"%lu Interests", (unsigned long)user.interests.count];
    [self.storage reloadItem:interestsModel];
    
    FRPhotosMutualFriendCellViewModel* mutualModel = [self.storage itemAtIndexPath:[NSIndexPath indexPathForRow:FRUserProfileCellTypeMutualFriend inSection:0]];
        
    if (user.mutualFriend.allObjects.count)
    {
        mutualModel.users = [user.mutualFriend.allObjects sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"firstName" ascending:true]]];
        mutualModel.isMyProfileCell = NO;
        [self.storage reloadItem:mutualModel];
    } else {
//        [self.storage removeItem:mutualModel];
    }
    
    [UIView setAnimationsEnabled:true];
    
}


#pragma mark - FRUserProfileHeaderCellViewModelDelegate

- (void)saveSelected
{
    [self.delegate saveSelected];
}

- (void)settingSelected:(NSString*)userId
{
    [self.delegate settingSelected:userId];
}

- (void)backSelected
{
    [self.delegate backSelected];
}

- (void)pendingSelected:(NSString*)userId
{
    
}

- (void)addFriendSelected:(NSString*)userId
{
    [self.delegate addFriendSelected:userId];
}

- (void)inviteToEventSelected:(NSString*)userId
{
    [self.delegate inviteToEventSelected:userId];
}

- (void)friendsSelected:(NSString*)userId
{
    
}

- (void) connectInstagram
{
    [self.delegate connectInstagram];
}

- (void)showPreviewWithImage:(UIImage*)image
{
    [self.delegate showPreviewWithImage:image];
}

-(void)showUserProfile:(NSString*)userId
{
    [self.delegate showUserProfile:userId];
}

-(void)showUserProfileWithEntity:(UserEntity*)user
{
    
}

#pragma mark - Private



@end
